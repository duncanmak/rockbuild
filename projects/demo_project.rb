require 'rockbuild/project'

include Rockbuild

class DemoProject < Project
  def components
    [
      entry(Autoconf.version('2.69'), PROFILE[:mac32], ConfigureMakeStrategy),
      entry(Automake.version('1.13'), PROFILE[:mac32], ConfigureMakeStrategy)
    ]
  end

  def bundle
    puts "DemoProject#bundle"
  end
end
