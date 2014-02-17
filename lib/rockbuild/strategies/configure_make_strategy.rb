include Rockbuild

module Rockbuild
  class ConfigureMakeStrategy < Strategy
    def setup(package, prefix = nil)
      puts "ConfigureMakeStrategy#configure for #{package.name}"
      puts "Changing into #{package.extracted_dir}..."

      Dir.chdir(package.extracted_dir) do
        configure "--prefix=#{prefix || Env.prefix}", merge_flags(package.configure_flags)
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
  end
end
