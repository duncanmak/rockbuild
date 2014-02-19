require 'fileutils'
require 'open-uri'

module Rockbuild
  class Package
    attr_reader :profile
    attr_reader :version
    attr_reader :source

    include Commands

    def initialize(ver, src)
      @version = ver
      @source = src
    end

    def self.sources
      raise 'Subclass must override and return { version => Source } hash.'
    end

    def deps
      []
    end

    def self.version(ver)
      self.new(ver, self.sources[ver])
    end

    def patches
      return [] unless self.class.respond_to?(:patches)

      hash = self.class.patches
      unless hash.nil?
        hash[version] || []
      else
        []
      end
    end

    def configure_flags
      []
    end

    # This should be overridden by subclasses.
    def name
      raise 'Should be overridden by subclass.'
    end

    def fetch
      deps.each do |dep, dep_strategy|
        dep.fetch
      end

      if is_cached?
        puts "#{name} is already downloaded, no need to download."
      else
        puts "Fetching #{name}..."
        source.retrieve(Env.download_dir)
      end

      if is_extracted?
        puts "#{name} is already extracted."
      else
        puts "Extracting #{name} to #{Env.build_root}..."

        mkdir_p(Env.build_root) unless File.exists?(Env.build_root)

        chdir(Env.build_root) do
          extract_from = "#{Env.download_dir}/#{source.filename}"
          source.extract(self, extract_from, extracted_dir)

          apply_patches
        end
      end
    end

    def is_extracted?
      File.exists?(extracted_dir)
    end

    def extracted_dir
      File.join(Env.build_root, extracted_basename)
    end

    def extracted_basename
      @source.extract_dirname(name, version)
    end

    def cached_filename
      source.url.split('/').last
    end

    def is_cached?
      File.exists?(File.join(Env.download_dir, cached_filename))
    end

    def build_success_file
      File.join(Env.build_root, "#{namever}.build")
    end

    def is_successful_build?
      def newer_than_sources?
        mtime = File.mtime(build_success_file)
        not (File.file?(source.filename) && File.mtime(source.filename) > mtime)
      end

      File.exists?(build_success_file) && newer_than_sources?
    end

    def build_is_successful!
      File.open(build_success_file, 'w')
    end

    def install_success_file
      File.join(Env.build_root, "#{namever}.install")
    end

    def is_successful_install?
      def newer_than_sources?
        mtime = File.mtime(install_success_file)
        not (File.file?(build_success_file) && File.mtime(build_success_file) > mtime)
      end

      File.exists?(install_success_file) && newer_than_sources?
    end

    def install_is_successful!
      File.open(install_success_file, 'w')
    end

    def namever
      "#{name}-#{version}"
    end

    def retrieve
      unless is_cached?
        source.retrieve(download_cache_dir)
      end
    end

    def self.descendants
      ObjectSpace.each_object(Class).select { |k| k < self }
    end

    private

    def apply_patches
      chdir(extracted_dir) do
        patches.each do |patch|
          patch.apply
        end
      end
    end

    def merge_flags(flags_array)
      flags_array.join(' ')
    end

    def lazy_merge_flags(flags_array)
      flags_array.map { |s| eval(%Q["#{s}"]) }.join(' ')
    end
  end
end
