require 'open-uri'

class Source
  def initialize(url, name: File.basename(url))
    @url = url
    @name = name
  end

  attr_reader :name, :url

  def download(destdir)
    puts "Downloading #{name} to #{destdir}"
    begin
      destfile = File.join(destdir, name)
      File.open(destfile, "wb") do |output|
        open(url) {|input| output.write(input.read)}
      end
    rescue Exception => e
      puts e.message
    end
  end

  def extract(directory, overwrite: true)
    location = File.join(directory, @name)
    FileUtils.rm_rf location if overwrite
    File.mkdir(location) unless File.exists?(location)

    Dir.chdir(location) do really_extract end
  end

  def really_extract
    puts "really_extract"
    raise "subclass responsibility"
  end
end

class TarGzSource < Source
  def really_extract
    `tar xf #{name}`
  end
end

class TarBz2Source < Source
  def really_extract
    `tar xf #{name}`
  end
end

class TarXzSource < Source
  def really_extract
    `tar xf #{name}`
  end
end

