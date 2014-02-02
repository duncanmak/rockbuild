require 'rockbuild/package'
require 'rockbuild/source'

include Rockbuild

class Gettext < Package
  def name
    'gettext'
  end

  def deps
    []
  end

  def configure_flags
    [
      '--disable-java',
      '--disable-libasprintf',
      '--disable-openmp'
    ]
  end

  def self.sources
    { '0.18.2' => Source.tar('http://ftp.gnu.org/gnu/gettext/gettext-0.18.2.tar.gz') }
  end
end