include Rockbuild

module Rockbuild
  class ConfigureMakeStrategy < Strategy
    def configure(package, profile)
      puts "ConfigureMakeStrategy#configure for #{package.name}"

      puts "Changing into #{package.extracted_dir}..."
      Dir.chdir(package.extracted_dir) do
        puts "./configure --prefix=#{Env.prefix}"
        `./configure --prefix=#{Env.prefix}`
      end
    end

    def prep(package, profile)
      puts "ConfigureMakeStrategy#prep for #{package.name}"
    end

    def build(package, profile)
      puts "ConfigureMakeStrategy#build for #{package.name}"
      puts "Changing into #{package.extracted_dir}..."
      Dir.chdir(package.extracted_dir) do
        puts "make"
        `make`
      end
    end

    def install(package, profile)
      puts "ConfigureMakeStrategy#install for #{package.name}"
      puts "Changing into #{package.extracted_dir}..."
      Dir.chdir(package.extracted_dir) do
        puts "make install"
        `make install`
      end
    end
  end
end
