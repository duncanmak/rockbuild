class Automake < Package
  def name
    'automake'
  end

  def version
    '1.13'
  end

  def sources
    [TargzSource.new("http://ftp.gnu.org/gnu/#{name}/#{name}-#{version}.tar.gz")]
  end
end