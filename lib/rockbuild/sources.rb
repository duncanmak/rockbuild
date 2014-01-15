require 'fileutils'
require 'open-uri'
require 'rockbuild/helpers'

module Rockbuild
  class Source
    include Rockbuild::Helpers

    class << self
      def targz(package, url)
        TarGzSource.new(package, url)
      end

      def tarbz2(package, url)
        TarBz2Source.new(package, url)
      end

      def tarxz(package, url)
        TarXzSource.new(package, url)
      end
    end

    def initialize(package, url)
      @package = package
      @url = url
    end

    attr_reader :url

    def namever
      File.basename(url).sub(/\.\w$/, '')
    end

    def filename() File.basename(url) end

    def retrieve
      download(@package.download_cache_dir) unless @package.is_cached?
    end

    def download(destdir)
      puts "Downloading #{url} to #{destdir}"
      begin
        destfile = File.join(destdir, filename)
        File.open(destfile, "wb") do |output|
          open(url) {|input| output.write(input.read)}
        end
      rescue Exception => e
        puts e.message
        File.delete(destfile)
      end
    end

    def extract(overwrite: false)
      profile = @package.profile

      Dir.chdir(profile.build_root) do
        cached_filename = "#{@package.download_cache_dir}/#{filename}"

        if overwrite || !File.exists?(@package.extracted_dir_name)
          puts "Extracting #{namever} in #{Dir.pwd}"
          extract!(cached_filename)
        else
          puts "Nothing to extract for #{namever}."
        end

        Dir.chdir(@package.extracted_dir_name) do
          puts @package.configure_command
          `#{@package.configure_command}`
        end
      end
    end

    private

    def extract!(cached_filename)
      puts "extract!"
      raise "subclass responsibility"
    end
  end

  class TarGzSource < Source
    private

    def extract!(cached_filename)
      puts tar 'xf', cached_filename
    end
  end

  class TarBz2Source < Source
    private

    def extract!(cached_filename)
      puts tar 'xf', cached_filename
    end
  end

  class TarXzSource < Source
    private

    def extract!(cached_filename)
      puts tar 'xf', cached_filename
    end
  end
end
