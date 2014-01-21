require 'zlib'
require 'rockbuild'
require 'rockbuild/helpers'

TAR_LONGLINK = '././@LongLink'
TYPEFLAG_SYMLINK = '2'

module Rockbuild
  class TarSource < Source
    include Rockbuild::Helpers

    private

    def mtime(cached_filename)
    end

    def tar(*args)
      `tar #{args * ' '}`
    end

    def extract!(cached_filename)
      tar 'xf', cached_filename
    end
  end
end
