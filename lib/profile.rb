
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
