require 'rockbuild/package'
require 'rockbuild/source'

include Rockbuild

class Gtk < Package
  def name
    'gtk+'
  end

  def deps
    [
      [ Atk.version('2.10.0'), ConfigureMakeStrategy.new ],
      [ Pango.version('1.36.1'), ConfigureMakeStrategy.new ],
      [ GdkPixbuf.version('2.30.3'), ConfigureMakeStrategy.new ]
    ]
  end

  def configure_flags
    case Env.host.to_s
    when /mac/
      [
        '--enable-quartz-backend',
        '--disable-x11-backend'
      ]
    when /linux/
      []
    else
      []
    end
  end

  def self.sources
    { '3.10.6' => Source.tar('http://ftp.gnome.org/pub/gnome/sources/gtk+/3.10/gtk+-3.10.6.tar.xz') }
  end

  def self.patches
    { '3.10.6' => [ Patch.new('gtk-3.10.6-fix-syntax-error-quartz.patch', 1) ] }
  end
end
