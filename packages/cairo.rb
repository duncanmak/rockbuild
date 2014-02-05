require 'rockbuild/package'
require 'rockbuild/source'

include Rockbuild

class Cairo < Package
  def name
    'cairo'
  end

  def configure_flags
    case Env.host
    when :mac
      [
        '--enable-pdf',
        '--enable-quartz',
        '--enable-quartz-font',
        '--enable-quartz-image',
        '--disable-xlib',
        '--without-x'
      ]
    when :linux
      [
        '--enable-pdf',
        '--disable-quartz',
        '--with-x'
      ]
    else
      [
        '--enable-pdf'
      ]
    end
  end

  def deps
    [
      [ Pixman.version('0.32.4'), ConfigureMakeStrategy.new ]
    ]
  end

  def self.sources
    { '1.12.16' => Source.tar('http://cairographics.org/releases/cairo-1.12.16.tar.xz')}
  end
end
