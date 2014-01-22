require 'open3'

include Rockbuild

module Rockbuild
  class ConfigureMakeStrategy < Strategy
    def configure(package, profile)
      puts "ConfigureMakeStrategy#configure for #{package.name}"

      puts "Changing into #{package.extracted_dir}..."
      Dir.chdir(package.extracted_dir) do
        puts configure_command(package)

        IO.popen(default_env(profile), configure_command(package)) do |io|
          until io.eof?
            puts io.gets
          end

          io.close

          if $?.to_i != 0
            puts "Failed to configure #{package.name}"
            exit(1)
          end
        end
      end
    end

    def prep(package, profile)
      puts "ConfigureMakeStrategy#prep for #{package.name}"
    end

    def build(package, profile)
      puts "ConfigureMakeStrategy#build for #{package.name}"
      puts "Changing into #{package.extracted_dir}..."
      Dir.chdir(package.extracted_dir) do
        puts "make -j"
        IO.popen(default_env(profile), 'make') do |io|
          until io.eof?
            puts io.gets
          end

          io.close

          if $?.to_i != 0
            puts "Failed to build #{package.name} (exit code #{$?.to_i})"
            exit(1)
          end
        end
      end
    end

    def install(package, profile)
      puts "ConfigureMakeStrategy#install for #{package.name}"
      puts "Changing into #{package.extracted_dir}..."
      Dir.chdir(package.extracted_dir) do
        puts "make install"
        Open3.popen3(default_env(profile), 'make install') do |i,o,e, wait_thread|
          until o.eof?
            puts o.gets
          end

          exit_status = wait_thread.value

          if exit_status != 0
            puts "Failed to make #{package.name}"
            exit(1)
          end
        end
      end
    end

    private

    def configure_command(package)
      "./configure --prefix=#{Env.prefix} #{merge_flags(package.configure_flags)}"
    end
  end
end
