require 'rockbuild/package'
require 'rockbuild/source'

include Rockbuild

class Automake < Package
  def name
    'automake'
  end

  def version
    '1.13'
  end

  def sources
    [Source.tar(self, "http://ftp.gnu.org/gnu/#{name}/#{name}-#{version}.tar.gz")]
  end
end
