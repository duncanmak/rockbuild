require 'rockbuild/project'

include Rockbuild

class DemoProject < Project
  def components
    [
      entry(Autoconf.version('2.69'), :mac32, ConfigureMakeStrategy),
      entry(Automake.version('1.13'), :mac32, ConfigureMakeStrategy),
#      entry(Mono.version('master'), :mac32, AutogenMakeStrategy),
      entry(Mono.version('master'), :mac32, LipoStrategy.new(AutogenMakeStrategy)),
#      entry(Gtk.version('3.10.6'), :mac32, ConfigureMakeStrategy)
    ]
  end

  def bundle
    puts "DemoProject#bundle"
  end
end
