require 'fileutils'
require 'open-uri'

module Rockbuild
  class Package
    # Subclasses must implement these accessors
    # attr_reader :name, :version

    def sources
      []
    end

    def build_success_file
      File.join(@root_directory, "#{self}.success")
    end

    def default_phases() [:retrieve, :prep, :build, :install] end

    # This is the method that gets things going
    def start(root_directory)
      FileUtils.mkdir_p root_directory unless File.exists?(root_directory)
      @root_directory = root_directory

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
      File.join(@root_directory, "_install")
    end

    def working_directory
      File.join(@root_directory, namever)
    end

    def namever() "#{name}-#{version}" end

    def retrieve
      sources.each do |s|
        s.retrieve(@root_directory)
      end
    end

    def configure
      "./configure --prefix=#{prefix}"
    end

    def prep
      puts "Package#prep"
    end

    def build
      puts "Package#build"
    end

    def install
      puts "Package#install"
    end
  end
end
