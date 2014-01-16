require 'rockbuild/package'
require 'rockbuild/source'

include Rockbuild

class Autoconf < Package
  def name
    'autoconf'
  end

  def version
    '2.69'
  end

  def source
    Source.tar(self, "http://ftp.gnu.org/gnu/#{name}/#{name}-#{version}.tar.gz")
  end
end
