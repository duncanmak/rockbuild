require 'fileutils'
require 'open-uri'
require 'rockbuild/helpers'

module Rockbuild
  class Source
    include Rockbuild::Helpers

    def initialize(url)
      @url = url
    end

    attr_reader :url

    def namever
      File.basename(url).sub(/\.\w$/, '')
    end

    def filename() File.basename(url) end

    def retrieve(destdir)
      download(destdir)
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

    def extract(package, overwrite: true)
      profile = package.profile

      Dir.chdir(profile.build_root) do
        puts "extracting #{namever} in #{Dir.pwd}"
        cached_filename = "#{package.download_cache_dir}/#{filename}"
        extract!(cached_filename)
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
