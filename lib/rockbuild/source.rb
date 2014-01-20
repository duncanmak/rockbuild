require 'fileutils'
require 'open-uri'

module Rockbuild
  class Source
    class << self
      def tar(package, url)
        TarSource.new(package, url)
      end

      def git(package, url)
        GitSource.new(package, url)
      end
    end

    def initialize(package, url)
      @package = package
      @url = url
    end

    attr_reader :package, :url

    def namever
      File.basename(url).sub(/\.\w$/, '')
    end

    def filename() File.basename(url) end

    def retrieve(dest_dir)
      download(dest_dir)
    end

    def download(destdir)
      puts "Downloading #{url} to #{destdir}"
      begin
        destfile = File.join(destdir, filename)

        FileUtils.mkdir_p(destdir) unless File.exists?(destdir)

        File.open(destfile, "wb") do |output|
          open(url) { |input| output.write(input.read) }
        end
      rescue Exception => e
        puts e.message
        File.delete(destfile)
      end
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
