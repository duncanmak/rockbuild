require 'rockbuild/project'

include Rockbuild

class DemoProject < Project
  def components
    [
      entry(Autoconf.version('2.69'), ConfigureMakeStrategy),
      entry(Automake.version('1.13'), ConfigureMakeStrategy),
#      entry(Mono.version('master'), AutogenMakeStrategy),
#      entry(Mono.version('master'), LipoStrategy.new(AutogenMakeStrategy)),
      entry(Gtk.version('3.10.6'), ConfigureMakeStrategy)
    ]
  end

  def bundle
    puts "DemoProject#bundle"
  end
end
