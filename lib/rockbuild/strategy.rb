module Rockbuild
  class Strategy
    include Commands

    def build_all(package)
      ensure_dependencies(package)

      unless package.is_successful_build?
        setup(package)

        build(package)
        package.build_is_successful!

        install(package)
      else
        puts "#{package.name} is already built, skipping."
      end

      unless package.is_successful_install?
        install(package)
        package.install_is_successful!
      else
        puts "#{package.name} is already installed, skipping."
      end
    end

    def fetch(package)
      package.fetch
    end

    def prep(package)
      raise "Strategy must implement 'prep'."
    end

    def setup(package)
      raise "Strategy must implement 'setup'."
    end

    def build(package)
      raise "Strategy must implement 'build'."
    end

    def install(package)
      raise "Strategy must implement 'install'."
    end

    private

    def ensure_dependencies(package)
      package.deps.each do |dep, dep_strategy|
        strat = dep_strategy.is_a?(Class) ? dep_strategy.new : dep_strategy
        strat.build_all(dep)
      end
    end
  end
end
