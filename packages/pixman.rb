require 'rockbuild/package'
require 'rockbuild/source'

include Rockbuild

class Pixman < Package
  def name
    'pixman'
  end

  def deps
    []
  end

  def self.sources
    { '0.32.4' => Source.tar('http://cairographics.org/releases/pixman-0.32.4.tar.gz') }
  end
end