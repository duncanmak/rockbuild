$stderr.sync = true
require 'optparse'

class Profile
  def initialize()
    @build_root = File.join(Dir.pwd, 'build-root')
  end

  def packages() raise "Subclass responsibility" end

  def start()
    packages.each do |pkg| pkg.start(@build_root) end
  end
end
