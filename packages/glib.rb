require 'rockbuild/package'
require 'rockbuild/source'

include Rockbuild

class Glib < Package
  def name
    'glib'
  end

  def deps
    [
      [ Gettext.version('0.18.2'), ConfigureMakeStrategy.new ],
      [ FFI.version('3.0.13'), ConfigureMakeStrategy.new ]
    ]
  end

  def self.sources
    { '2.38.2' => Source.tar('http://ftp.gnome.org/pub/gnome/sources/glib/2.38/glib-2.38.2.tar.xz') }
  end
end
