require 'rbconfig'
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

      def host
        @@host ||= (
          host_os = RbConfig::CONFIG['host_os']
          case host_os
          when /darwin|mac os/
            :mac
          when /linux/
            :linux
          when /solaris|bsd/
            :unix
          when /mswin|msys|mingw|cygwin|bccwin|wince|wmc/
            :windows
          else
            raise "Unknown OS: #{host_os.inspect}"
          end
        )
      end
    end
  end
end
