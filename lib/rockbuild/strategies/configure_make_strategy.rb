include Rockbuild

module Rockbuild
  class ConfigureMakeStrategy < Strategy
    include Commands

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
        make "-j 8"
      end
    end

    def install(package)
      puts "ConfigureMakeStrategy#install for #{package.name}"
      puts "Changing into #{package.extracted_dir}..."
      Dir.chdir(package.extracted_dir) do
        make "install"
      end
    end

    private

    def configure_command(package, prefix)
      configure "--prefix=#{prefix}", merge_flags(package.configure_flags)
    end
  end
end
