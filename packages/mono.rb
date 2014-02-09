require 'rockbuild/package'
require 'rockbuild/source'

include Rockbuild

class Mono < Package
  def name
    'mono'
  end

  def deps
    [
      [ Llvm.version('3.0'), ConfigureMakeStrategy.new ]
    ]
  end

  def configure_flags
    case Env.host
    when :mac
      base = [
        '--enable-nls=no',
        '--with-ikvm=yes',
        '--with-moonlight=no',
        '--enable-loadedllvm'
      ]

      if Env.profile == :mac32
        target = [ '--build=i386-apple-darwin11.2.0' ]
      elsif Env.profile == :mac64
        target = [ '--build=x86_64-apple-darwin13.0.0' ]
      end

      base + target
    when :linux
    else
    end
  end

  def self.sources
    { 'master' => Source.git('git://github.com/mono/mono.git') }
  end
end
