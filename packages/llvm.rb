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
      base = [
        '--enable-optimized',
        '--enable-targets="x86 x86_64"'
      ]

      if Env.profile == :mac32
        target = [ '--build=i386-apple-darwin11.2.0' ]
      elsif Env.profile == :mac64
        target = [ '--build=x86_64-apple-darwin13.0.0' ]
      end
    when :linux
    else
    end
  end

  def self.sources
    { '3.0' => Source.git('git://github.com/mono/llvm.git') }
  end
end
