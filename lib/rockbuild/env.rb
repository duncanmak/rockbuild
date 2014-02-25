require 'rbconfig'
require 'singleton'

module Rockbuild
  class Env
    include Singleton

    class << self
      def default_settings
        { root: Dir.pwd }
      end

      def settings
        @@settings ||= default_settings
      end

      def profile
        settings[:profile]
      end

      def with_profile(profile, &block)
        with_settings({ profile: profile }) { block.call }
      end

      def with_settings(_settings, &block)
        _settings = Hash[_settings.map{|(k,v)| [k.to_sym,v]}]
        old_settings = settings
        @@settings = old_settings.merge _settings

        begin
          block.call
        ensure
          @@settings = old_settings
        end
      end

      def root
        settings[:root]
      end

      def build_root
        File.join(root, 'build-root', Env.profile.to_s)
      end

      def download_dir
        File.join(root, 'cache')
      end

      def prefix
        File.join(build_root, '_install')
      end

      def tmpdir
        File.join(build_root, 'build-root', '_tmp')
      end

      def host
        @@host ||= (
          packsize = ['a'].pack('p').size
          bits = case packsize
          when 8
            64
          when 4
            32
          else
            raise "Failed to detect if this is a 32-bit or 64-bit host."
          end

          host_os = RbConfig::CONFIG['host_os']
          case host_os
          when /darwin|mac os/
            "mac#{bits}".to_sym
          when /linux/
            "linux#{bits}".to_sym
          when /solaris|bsd/
            :unix
          when /mswin|msys|mingw|cygwin|bccwin|wince|wmc/
            :windows
          else
            raise "Unknown OS: #{host_os.inspect}"
          end
        )
      end

      def dry_run?
        settings[:dry_run]
      end

      def quiet?
        settings[:quiet]
      end
    end
  end
end
