require 'rockbuild/package'
require 'rockbuild/source'

include Rockbuild

class Gtk < Package
  def name
    'gtk+'
  end

  def deps
    [
      Atk.version('2.10.0'),
      Pango.version('1.36.1')
    ]
  end

  def configure_flags
    case Env.host
    when :mac
      '--with-gdktarget=quartz'
    when :linux
    else
    end
  end

  def self.sources
    { '3.10.6' => Source.tar('http://ftp.gnome.org/pub/gnome/sources/gtk+/3.10/gtk+-3.10.6.tar.xz') }
  end
end