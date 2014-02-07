module Rockbuild
  class Strategy
    def build_all(package)
      ensure_dependencies(package)

      unless package.is_successful_build?
        configure(package)

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

    def prep(package)
      raise "Strategy must implement 'prep'."
    end

    def build(package)
      raise "Strategy must implement 'build'."
    end

    def install(package)
      raise "Strategy must implement 'install'."
    end

    private

    def default_env
      profile = Env.profile

      {
        'PATH'            => merge_flags(profile[:path], ':'),
        'CFLAGS'          => merge_flags(profile[:cflags]),
        'CPPFLAGS'        => merge_flags(profile[:cflags]),
        'CXXFLAGS'        => merge_flags(profile[:cflags]),
        'LDFLAGS'         => merge_flags(profile[:ldflags]),
        'PKG_CONFIG_PATH' => "#{Env.prefix}/lib/pkgconfig"
      }
    end

    def merge_flags(flags_array, separator = ' ')
      flags_array.join(separator)
    end

    def ensure_dependencies(package)
      package.deps.each do |dep, dep_strategy|
        dep_strategy.build_all(dep)
      end
    end
  end
end
