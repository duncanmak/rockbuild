require 'zlib'
require 'rockbuild'
require 'rockbuild/helpers'

TAR_LONGLINK = '././@LongLink'
TYPEFLAG_SYMLINK = '2'

module Rockbuild
  class TarSource < Source
    include Rockbuild::Helpers

    def retrieve(destdir)
      puts "Retrieving #{url} to #{destdir}"
      begin
        destfile = File.join(destdir, filename)

        mkdir_p(destdir) unless File.exists?(destdir)

        download_file(destfile, url)
      rescue Exception => e
        puts e.message
        delete(destfile)
      end
    end

    private

    def mtime(cached_filename)
    end

    def tar(*args)
      _run('tar', args)
    end

    def extract!(cached_filename)
      tar 'xf', cached_filename
    end
  end
end
