require 'rockbuild/package'
require 'rockbuild/source'

include Rockbuild

class Automake < Package
  def name
    'automake'
  end

  def self.sources
    { '1.13' => Source.tar(self, 'http://ftp.gnu.org/gnu/automake/automake-1.13.tar.gz') }
  end
end
