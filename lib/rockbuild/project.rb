module Rockbuild
  class Project
    def entry(package, profile, strategy)
      [ package, profile, strategy.new ]
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
      puts "Project#prep"

      components.each do |package, profile, strategy|
        strategy.prep(package, profile)
      end
    end

    def fetch
      puts "Project#fetch"

      components.each do |package, profile, strategy|
        package.fetch
      end
    end

    def build
      puts "Project#build"

      components.each do |package, profile, strategy|
        strategy.build_all(package, profile)
      end
    end

    def bundle
      raise 'Must implement.'
    end
  end
end
