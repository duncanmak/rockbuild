include Rockbuild

class GitSource < Source
  def initialize(url, options)
    @url = url
    @branch = options.delete(:branch)
    @revision = options.delete(:revision)
  end

  def git(*args)
    _run('git', args)
  end

  def retrieve(destdir)
    puts "download(destdir=#{destdir})"
    dest = File.join(destdir, @url.split(/\//).last.gsub(/\.git/, ''))
    if File.exists?(dest)
      puts 'Updating existing cache.'
      chdir(dest) do
        git 'fetch --all --prune'
      end
    else
      puts 'No cache detected. Cloning a fresh one.'
      chdir(destdir) do
        git "clone", "--mirror", @url
      end
    end
  end

  def extract_dirname(name, version)
    name
  end

  private

  def extract!(cached_filename)
    dest = @url.split(/\//).last.gsub(/\.git/, '')
    if !File.exists?(dest)
      puts "No workspace checkout detected. Cloning a fresh workspace checkout from the cache."
      git "clone --local --shared #{cached_filename}"
    else
      puts "Updating existing workspace checkout."
      chdir(dest) do
        git 'clean -xffd'
        git 'reset --hard'
        git 'fetch --all --prune'
      end
    end
  end
end
