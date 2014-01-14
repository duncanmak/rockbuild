cwd = File.expand_path('../', __FILE__)
Dir["#{cwd}/../../packages/**/*.rb"].each do |pkg| puts pkg; require pkg end

module Rockbuild
  class Profile
    def initialize()
      @root = Dir.pwd
      @build_root = File.join(@root, 'build-root')
    end

    attr_reader :root
    attr_reader :build_root

    def packages
      []
    end

    def start
      packages.each do |pkg|
        pkg = pkg.new(self)

        pkg.start
      end
    end
  end
end
