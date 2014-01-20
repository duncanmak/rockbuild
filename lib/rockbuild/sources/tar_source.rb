require 'zlib'
require 'rockbuild'

TAR_LONGLINK = '././@LongLink'
TYPEFLAG_SYMLINK = '2'

module Rockbuild
  class TarSource < Source
    include Rockbuild::Helpers

    private

    def mtime(cached_filename)
    end

    def tar(*args)
      `#{tar_bin} #{args * ' '}`
    end

    def tar_bin
      common_bin_path('tar')
    end

    def extract!(cached_filename)
      tar 'xf', cached_filename
    end
  end
end
