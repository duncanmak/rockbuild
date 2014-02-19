require 'fileutils'
require 'open-uri'

module Rockbuild
  class Source
    include Commands

    class << self
      def tar(url)
        TarSource.new(url)
      end

      def git(url, options = {})
        GitSource.new(url, options)
      end
    end

    def initialize(url)
      @url = url
    end

    attr_reader :url

    def namever
      File.basename(url).sub(/\.\w$/, '')
    end

    def filename() File.basename(url) end

    def retrieve(dest_dir)
      puts "Fetching #{url} to #{dest_dir}"
      download(dest_dir)
    end

    def download(destdir)
      puts "Downloading #{url} to #{destdir}"
      begin
        destfile = File.join(destdir, filename)

        mkdir_p(destdir) unless File.exists?(destdir)

        download_file(destfile, url)
      rescue Exception => e
        puts e.message
        delete(destfile)
      end
    end

    def extract_dirname(name, version)
      "#{name}-#{version}"
    end

    def extract(package, cached_filename, extracted_dir, overwrite: false)
      if overwrite || !File.exists?(extracted_dir)
        puts "Extracting #{namever} in #{Dir.pwd}"
        extract!(cached_filename)
      else
        puts "Nothing to extract for #{namever}."
      end
    end

    private

    def extract!(cached_filename)
      puts "extract!"
      raise "subclass responsibility"
    end
  end
end
