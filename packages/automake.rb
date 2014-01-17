require 'rockbuild/package'
require 'rockbuild/source'

include Rockbuild

class Automake < Package
  def name
    'automake'
  end

  def self.sources
    { '1.13' => Source.tar(self, 'http://ftp.gnu.org/gnu/#{name}/#{name}-#{version}.tar.gz') }
  end
end
