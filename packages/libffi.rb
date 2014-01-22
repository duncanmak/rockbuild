require 'rockbuild/package'
require 'rockbuild/source'

include Rockbuild

class FFI < Package
  def name
    'libffi'
  end

  def deps
    []
  end

  def self.sources
    { '3.0.13' => Source.tar('ftp://sourceware.org/pub/libffi/libffi-3.0.13.tar.gz') }
  end
end