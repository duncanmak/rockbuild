require 'minitest/autorun'
require 'rockbuild'

include Rockbuild

class TestPackage < Minitest::Test
  def setup
    @package = Package.new
  end

  def test_has_empty_sources
    assert_empty @package.sources
  end
end
