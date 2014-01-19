require 'rubygems/package'
require 'zlib'
require 'rockbuild'
require 'debugger'

TAR_LONGLINK = '././@LongLink'
TYPEFLAG_SYMLINK = '2'

module Rockbuild
  class TarSource < Source
    private

    def mtime(cached_filename)
    end

    def extract!(cached_filename)
      Gem::Package::TarReader.new(Zlib::GzipReader.open(cached_filename)) do |tar|
        dest = nil

        tar.each do |entry|
          if entry.full_name == TAR_LONGLINK
            dest = File.join(Env.build_root, entry.read.strip)
            next
          end

          dest ||= File.join(Env.build_root, entry.full_name)
          if entry.directory?
            FileUtils.rm_rf(dest) unless File.directory?(dest)
            FileUtils.mkdir_p(dest, mode: entry.header.mode, verbose: false)
          elsif entry.file? || entry.header.typeflag == ''
            FileUtils.rm_rf(dest) unless File.file?(dest)
            File.open(dest, "wb") do |f|
              f.print(entry.read)
            end

            FileUtils.chmod entry.header.mode, dest, :verbose => false
          elsif entry.header.typeflag == '2' #Symlink!
            File.symlink entry.header.linkname, dest
          end

          dest = nil
        end
      end
    end
  end
end
