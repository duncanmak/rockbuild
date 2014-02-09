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
      [
        '--enable-nls=no',
        '--with-ikvm=yes',
        '--with-moonlight=no',
        '--enable-loadedllvm'
      ]
    when :linux
    else
    end
  end

  def self.sources
    { 'master' => Source.git('git://github.com/mono/mono.git') }
  end
end
