module Rockbuild
  class Strategy
    def build_all(package, profile)
      ensure_dependencies(package, profile)

      unless package.is_successful_build?
        configure(package, profile)

        build(package, profile)
        package.build_is_successful!

        install(package, profile)
      else
        puts "#{package.name} is already built, skipping."
      end

      unless package.is_successful_install?
        install(package, profile)
        package.install_is_successful!
      else
        puts "#{package.name} is already installed, skipping."
      end
    end

    def prep(package, profile)
      raise "Strategy must implement 'prep'."
    end

    def build(package, profile)
      raise "Strategy must implement 'build'."
    end

    def install(package, profile)
      raise "Strategy must implement 'install'."
    end

    private

    def default_env(profile)
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

    def ensure_dependencies(package, profile)
      package.deps.each do |dep|
        build_all(dep, profile)
      end
    end
  end
end
