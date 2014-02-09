require 'rockbuild/package'
require 'rockbuild/source'

include Rockbuild

class Llvm < Package
  def name
    'llvm'
  end

  def deps
    [
    ]
  end

  def configure_flags
    case Env.host
    when :mac
      [
        '--enable-optimized',
        '--enable-targets="x86 x86_64"'
      ]
    when :linux
    else
    end
  end

  def self.sources
    { '3.0' => Source.git('git://github.com/mono/llvm.git') }
  end
end
