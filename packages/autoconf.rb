require 'rockbuild/package'
require 'rockbuild/source'

include Rockbuild

class Autoconf < Package
  def name
    'autoconf'
  end

  def self.sources
    { '2.69' => Source.tar('http://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz') }
  end
end
