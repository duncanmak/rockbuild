require 'fileutils'
require 'open-uri'

module Rockbuild
  class Package
    attr_reader :profile
    attr_reader :version
    attr_reader :source

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
      []
    end

    def configure_flags
      []
    end

    # This should be overridden by subclasses.
    def name
      raise 'Should be overridden by subclass.'
    end

    def fetch
      deps.each do |dep|
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

        FileUtils.mkdir_p(Env.build_root) unless File.exists?(Env.build_root)

        Dir.chdir(Env.build_root) do
          extract_from = "#{Env.download_dir}/#{source.filename}"
          source.extract(self, extract_from, extracted_dir)
        end
      end
    end

    def is_extracted?
      File.exists?(extracted_dir)
    end

    def extracted_dir
      File.join(Env.build_root, namever)
    end

    def cached_filename
      source.url.split('/').last
    end

    def is_cached?
      File.exists?(File.join(Env.download_dir, cached_filename))
    end

    def build_success_file
      File.join(build_root, "#{namever}.success")
    end


    # This is the method that gets things going
    def start
      FileUtils.mkdir_p(Env.build_root) unless File.exists?(build_root)
      FileUtils.mkdir_p(download_cache_dir) unless File.exists?(download_cache_dir)

      phases = default_phases

      if is_successful_build?()
        puts "Skipping #{name} - already build"
        phases = [:install]
      end

      phases.each { |phase| (send phase) }
    end

    def is_successful_build?
      def newer_than_sources?
        mtime = File.mtime(build_success_file)
        not (File.file?(source.filename) && File.mtime(source.filename) > mtime)
      end

      File.exists?(build_success_file) && newer_than_sources?
    end

    def namever
      "#{name}-#{version}"
    end

    def retrieve
      unless is_cached?
        source.retrieve(download_cache_dir)
      end
    end

    def install
      puts "make install"
      Dir.chdir(extracted_dir_name) do
        `make install`
      end
    end

    private

    def merge_flags(flags_array)
      flags_array.join(' ')
    end

    def lazy_merge_flags(flags_array)
      flags_array.map { |s| eval(%Q["#{s}"]) }.join(' ')
    end
  end
end
