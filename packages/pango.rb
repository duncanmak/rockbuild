require 'rockbuild/package'
require 'rockbuild/source'

include Rockbuild

class Pango < Package
  def name
    'pango'
  end

  def configure_flags
    [
      '--without-x'
    ]
  end

  def deps
    [
      [ Cairo.version('1.12.16'), ConfigureMakeStrategy.new ]
    ]
  end

  def self.sources
    { '1.36.1' => Source.tar('http://ftp.gnome.org/pub/gnome/sources/pango/1.36/pango-1.36.1.tar.xz') }
  end
end
