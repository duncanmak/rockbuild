require 'rockbuild/package'
require 'rockbuild/source'

include Rockbuild

class GdkPixbuf < Package
  def name
    'gdk-pixbuf'
  end

  def self.sources
    { '2.28.2' => Source.tar('http://ftp.gnome.org/pub/gnome/sources/gdk-pixbuf/2.28/gdk-pixbuf-2.28.2.tar.xz') }
    { '2.30.3' => Source.tar('http://ftp.gnome.org/pub/gnome/sources/gdk-pixbuf/2.30/gdk-pixbuf-2.30.3.tar.xz') }
  end
end
