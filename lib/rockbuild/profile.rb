cwd = File.expand_path('../', __FILE__)
Dir["#{cwd}/../../packages/**/*.rb"].each do |pkg| puts pkg; require pkg end

module Rockbuild
  class Profile
    def initialize()
      @build_root = File.join(Dir.pwd, 'build-root')

    end

    attr_reader :build_root

    def packages() raise "Subclass responsibility" end

    def start()
      packages.each do |pkg|
        pkg = pkg.new if pkg.is_a? Class

        pkg.start(@build_root)
      end
    end
  end
end
