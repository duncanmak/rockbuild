require 'rbconfig'
require 'singleton'

module Rockbuild
  class Env
    include Singleton

    class << self
      def profile
        @@profiles ||= Array.new
        @@profiles.last
      end

      def with_profile(profile)
        @@profiles ||= Array.new
        @@profiles.push(profile)

        yield if block_given?

        @@profiles.pop
      end

      def root
        @@root ||= Dir.pwd
      end

      def build_root
        File.join(root, 'build-root', Env.profile.to_s)
      end

      def download_dir
        @@download_dir ||= File.join(root, 'cache')
      end

      def prefix
        File.join(build_root, '_install')
      end

      def tmpdir
        File.join(build_root, 'build-root', '_tmp')
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
