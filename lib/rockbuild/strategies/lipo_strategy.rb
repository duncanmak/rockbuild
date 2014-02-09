module Rockbuild
  class LipoStrategy < Strategy
    def initialize(base_strategy)
      @base_strategy = base_strategy.is_a?(Class) ? base_strategy.new : base_strategy
    end

    def prep(package)
    end

    def fetch(package)
      [:mac32, :mac64].each do |profile|
        Env.with_profile(profile) do
          @base_strategy.fetch(package)
        end
      end
    end

    def build_all(package)
      tempdir = File.join(Env.tmpdir, package.extracted_basename)
      bins = []

      [:mac32, :mac64].each do |profile|
        Env.with_profile(profile) do
          @base_strategy.build_all(package)
        end
      end

      Env.with_profile(:mac64) do
        Dir.chdir(Env.prefix) do
          bins += `find . -type f | xargs file | sed -e \"s,^.,,g\" | grep -E \"(Mach-O)\|\(ar\ archive\)\" | sed -e 's,:.*,,g' -e '/\for\ architecture/d'`.split("\n")
        end
      end

      bins.each do |bin|
        puts "Processing #{bin}..."
        bin32 = File.join(Env.root, 'build-root', 'mac32', '_install', bin)
        bin64 = File.join(Env.root, 'build-root', 'mac64', '_install', bin)
        puts "/usr/bin/lipo -create #{bin32} #{bin64} -output #{bin64}"
        `/usr/bin/lipo -create #{bin32} #{bin64} -output #{bin64}`
      end
    end

    private

    def ensure_dependencies
      packages.deps.each do |dep, strategy|
        LipoStrategy.new(strategy).build_all(dep)
      end
    end
  end
end

