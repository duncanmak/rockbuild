include Rockbuild

module Rockbuild
  class ConfigureMakeStrategy < Strategy
    def configure(package)
      puts "ConfigureMakeStrategy#configure for #{package.name}"

      puts "Changing into #{package.extracted_dir}..."
      Dir.chdir(package.extracted_dir) do
        puts configure_command(package)

        IO.popen(default_env, configure_command(package)) do |io|
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

    def prep(package)
      puts "ConfigureMakeStrategy#prep for #{package.name}"
    end

    def build(package)
      puts "ConfigureMakeStrategy#build for #{package.name}"
      puts "Changing into #{package.extracted_dir}..."
      Dir.chdir(package.extracted_dir) do
        puts "make -j"
        IO.popen(default_env, 'make') do |io|
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

    def install(package)
      puts "ConfigureMakeStrategy#install for #{package.name}"
      puts "Changing into #{package.extracted_dir}..."
      Dir.chdir(package.extracted_dir) do
        puts "make install"
        IO.popen(default_env, 'make install') do |io|
          until io.eof?
            puts io.gets
          end

          io.close

          if $?.to_i != 0
            puts "Failed to install #{package.name} (exit code #{$?.to_i})"
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
