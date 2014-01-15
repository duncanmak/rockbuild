require 'rockbuild/package'
require 'rockbuild/sources'

include Rockbuild

class Autoconf < Package
  def name
    'autoconf'
  end

  def version
    '2.69'
  end

  def sources
    [TarGzSource.new(self, "http://ftp.gnu.org/gnu/#{name}/#{name}-#{version}.tar.gz")]
  end
end
