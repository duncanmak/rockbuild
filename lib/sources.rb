require 'fileutils'
require 'open-uri'

class Source
  include Helpers

  def initialize(url)
    @url = url
  end

  attr_reader :url

  def namever
    File.basename(url).sub(/\.\w$/, '')
  end

  def filename() File.basename(url) end

  def retrieve(destdir)
    download(destdir)
    extract(destdir)
  end

  def download(destdir)
    puts "Downloading #{url} to #{destdir}"
    begin
      destfile = File.join(destdir, filename)
      File.open(destfile, "wb") do |output|
        open(url) {|input| output.write(input.read)}
      end
    rescue Exception => e
      puts e.message
      File.delete(destfile)
    end
  end

  def extract(directory, overwrite: true)
    Dir.chdir(directory) do
      puts "extracting #{namever} in #{Dir.pwd}"
      extract!
    end
  end

  private

  def extract!
    puts "extract!"
    raise "subclass responsibility"
  end
end

class TarGzSource < Source
  private

  def extract!
    puts tar 'xf', filename
  end
end

class TarBz2Source < Source
  private

  def extract!
    puts tar 'xf', filename
  end
end

class TarXzSource < Source
  private

  def extract!
    puts tar 'xf', filename
  end
end

