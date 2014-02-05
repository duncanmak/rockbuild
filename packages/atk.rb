require 'rockbuild/package'
require 'rockbuild/source'

include Rockbuild

class Atk < Package
  def name
    'atk'
  end

  def deps
    [
      [ Glib.version('2.38.2'), ConfigureMakeStrategy.new ]
    ]
  end

  def self.sources
    { '2.10.0' => Source.tar('http://ftp.gnome.org/pub/gnome/sources/atk/2.10/atk-2.10.0.tar.xz') }
  end
end
