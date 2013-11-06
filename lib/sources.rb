
class Source
  def initialize(name, file)
    @name = name
    @file = file
  end

  def extract(directory, overwrite: true)
    location = File.join(directory, @name)
    FileUtils.rm_rf location if overwrite
    Dir.chdir(location) do really_extract! end
  end

  def really_extract!
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

