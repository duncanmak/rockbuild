require 'fileutils'
require 'open-uri'

module Rockbuild
  class Package
    attr_reader :profile

    # This should be overridden by subclasses.
    def source
      raise 'Should be overridden by subclass.'
    end

    def patches
      []
    end

    # This should be overridden by subclasses.
    def name
      raise 'Should be overridden by subclass.'
    end

    # Thisshould be overridden by subclasses.
    def version
      raise 'Should be overridden by subclass.'
    end

    def initialize(profile)
      @profile = profile
    end

    def build_root
      @profile.build_root
    end

    def install_prefix
      @profile.install_prefix
    end

    def download_cache_dir
      File.join(@profile.root, 'cache')
    end

    def cached_filename
      source.url.split('/').last
    end

    def is_cached?
      File.exists?(File.join(download_cache_dir, cached_filename))
    end

    def extracted_dir_name
      File.join(build_root, namever)
    end

    def build_success_file
      File.join(build_root, "#{namever}.success")
    end

    def default_phases() [:retrieve, :prep, :build, :install] end

    # This is the method that gets things going
    def start
      FileUtils.mkdir_p(build_root) unless File.exists?(build_root)
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

    def working_directory
      File.join(build_root, namever)
    end

    def namever
      "#{name}-#{version}"
    end

    def retrieve
      unless is_cached?
        source.retrieve(download_cache_dir)
      end
    end

    def configure_command
      "./configure --prefix=#{install_prefix}"
    end

    def prep
      Dir.chdir(profile.build_root) do
        extract_from = "#{download_cache_dir}/#{source.filename}"
        source.extract(extract_from)
      end
    end

    def build
      puts "make"
      Dir.chdir(extracted_dir_name) do
        `make`
        File.open(build_success_file, 'w')
      end
    end

    def install
      puts "make install"
      Dir.chdir(extracted_dir_name) do
        `make install`
      end
    end
  end
end
