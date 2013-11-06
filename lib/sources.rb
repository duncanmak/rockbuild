
class Source
  def initialize(file, name: File.basename(file))
    @file = file
    @name = name
  end

  def extract(directory, overwrite: true)
    location = File.join(directory, @name)
    FileUtils.rm_rf location if overwrite
    File.mkdir(location) unless File.exists?(location)

    Dir.chdir(location) do really_extract! end
  end

  def really_extract!
    raise "subclass responsibility"
  end
end

class TarGzSource < Source
  def really_extract!
    `tar xf #{name}`
  end
end

class TarBz2Source < Source
  def really_extract!
    `tar xf #{name}`
  end
end

class TarXzSource < Source
  def really_extract!
    `tar xf #{name}`
  end
end

