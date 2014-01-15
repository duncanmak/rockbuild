require 'fileutils'
require 'open-uri'

module Rockbuild
  class Package
    # Subclasses must implement these accessors
    # attr_reader :name, :version
    attr_reader :profile

    def initialize(profile)
      @profile = profile
    end

    def build_root
      @profile.build_root
    end

    def download_cache_dir
      File.join(@profile.root, 'cache')
    end

    def cached_filename
      sources.first.url.split('/').last
    end

    def is_cached?
      File.exists?(File.join(download_cache_dir, cached_filename))
    end

    def extracted_dir_name
      File.join(build_root, "#{name}-#{version}")
    end

    # This should be overridden by subclasses.
    def sources
      []
    end

    def build_success_file
      File.join(build_root, "#{self}.success")
    end

    def default_phases() [:retrieve, :prep, :build, :install] end

    # This is the method that gets things going
    def start
      FileUtils.mkdir_p(build_root) unless File.exists?(build_root)
      FileUtils.mkdir_p(download_cache_dir) unless File.exists?(download_cache_dir)

      phases = default_phases

      if is_successful_build?()
        log "Skipping #{self} - already build"
        phases = [:install]
      end

      phases.each { |phase| (send phase) }
    end

    def is_successful_build?
      def newer_than_sources?
        mtime = File.mtime(build_success_file)
        not sources.select { |s| File.file?(s) && File.mtime(s) > mtime }.empty?
      end

      File.exists?(build_success_file) && newer_than_sources?
    end

    def prefix
      File.join(build_root, "_install")
    end

    def working_directory
      File.join(build_root, namever)
    end

    def namever() "#{name}-#{version}" end

    def retrieve
      sources.each do |s|
        s.retrieve
      end
    end

    def configure
      "./configure --prefix=#{prefix}"
    end

    def prep
      sources.each do |s|
        s.extract
      end
    end

    def build
      puts "make"
      Dir.chdir(extracted_dir_name) do
        `make`
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
