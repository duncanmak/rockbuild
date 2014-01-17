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

    def build(package, profile)
    end

    def install(package, profile)
    end
  end
end
