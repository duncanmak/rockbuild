class Autoconf < Package
  def name
    'autoconf'
  end

  def version
    '2.69'
  end

  def sources
    [TargzSource.new("http://ftp.gnu.org/gnu/#{name}/#{name}-#{version}.tar.gz")]
  end
end
