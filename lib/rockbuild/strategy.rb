#cwd = File.expand_path('../', __FILE__)
#Dir["#{cwd}/strategies/**/*.rb"].each do |pkg| puts pkg; require pkg end

module Rockbuild
  class Strategy
    # def initialize(configure: nil, build: nil, install: nil)
    #   @configure = configure
    #   @build = build
    #   @install = install
    # end

    # def configure(package, profile)
    #   @configure.call(package, profile) unless @configure.nil?
    # end

    def prep(package, profile)
      raise "Strategy must implement 'prep'."
    end

    def build(package, profile)
      raise "Strategy must implement 'build'."
    end

    def install(package, profile)
      raise "Strategy must implement 'install'."
    end
  end
end
