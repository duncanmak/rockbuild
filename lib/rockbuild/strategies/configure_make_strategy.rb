include Rockbuild

module Rockbuild
  class ConfigureMakeStrategy < Strategy
    def configure(package, prefix = nil)
      puts "ConfigureMakeStrategy#configure for #{package.name}"
      puts "Changing into #{package.extracted_dir}..."

      Dir.chdir(package.extracted_dir) do
        do_configure(package, prefix)
      end
    end

    def do_configure(package, prefix = nil)
      puts configure_command(package, prefix || Env.prefix)

      IO.popen(default_env, configure_command(package, prefix || Env.prefix)) do |io|
        until io.eof?
          io.gets
        end

        io.close

        if $?.to_i != 0
          puts "Failed to configure #{package.name}"
          puts "ENVIRONMENT:"
          puts default_env.inspect
          exit(1)
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
        puts "make -j 8"
        IO.popen(default_env, 'make -j 8') do |io|
          until io.eof?
            io.gets
          end

          io.close

          if $?.to_i != 0
            puts "Failed to build #{package.name} (exit code #{$?.to_i})"
            puts "ENVIRONMENT:"
            puts default_env.inspect
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
            io.gets
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

    def configure_command(package, prefix)
      "./configure --prefix=#{prefix} #{merge_flags(package.configure_flags)}"
    end
  end
end
