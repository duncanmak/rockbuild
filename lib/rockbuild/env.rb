require 'singleton'

module Rockbuild
  class Env
    include Singleton

    class << self
      def root
        @@root ||= Dir.pwd
      end

      def build_root
        @@build_root ||= File.join(root, 'build-root')
      end

      def download_dir
        @@download_dir ||= File.join(root, 'cache')
      end

      def prefix
        @@prefix ||= File.join(build_root, '_install')
      end
    end
  end
end
