module Rockbuild
  class Project
    def initialize
      @root = Dir.pwd
      @build_root = File.join(@root, 'build-root')
      @download_dir = File.join(@root, 'cache')
    end

    def entry(package, profile, strategy)
      [ package, profile, strategy.new ]
    end

    attr_reader :root
    attr_reader :build_root
    attr_reader :download_dir

    def install_prefix
      File.join(build_root, "_install")
    end

    # This should be overridden
    def components
      []
    end

    def start
      puts "Project#start"
      [:fetch, :prep, :build, :bundle].each { |stage| self.send(stage) }
    end

    def prep
      raise 'Must implement.'
    end

    def fetch
      puts "Project#fetch"

      components.each do |package, profile, strategy|
        package.fetch(download_dir)
      end
    end

    def build
      puts "Project#build"

      components.each do |package, profile, strategy|
        strategy.configure(package, profile)
        strategy.build(package, profile)
        strategy.install(package, profile)
      end
    end

    def bundle
      raise 'Must implement.'
    end
  end
end
