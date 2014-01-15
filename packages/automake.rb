require 'rockbuild/package'
require 'rockbuild/sources'

include Rockbuild

class Automake < Package
  def name
    'automake'
  end

  def version
    '1.13'
  end

  def sources
    [Source.targz(self, "http://ftp.gnu.org/gnu/#{name}/#{name}-#{version}.tar.gz")]
  end
end
