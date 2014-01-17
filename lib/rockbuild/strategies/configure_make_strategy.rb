include Rockbuild

module Rockbuild
  class ConfigureMakeStrategy < Strategy
    def configure(package, profile)
      puts "ConfigureMakeStrategy#configure for #{package.name}"
    end

    def build(package, profile)
      puts "ConfigureMakeStrategy#build for #{package.name}"
    end

    def install(package, profile)
      puts "ConfigureMakeStrategy#install for #{package.name}"
    end
  end
end
