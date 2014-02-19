require 'minitest/autorun'
require 'rockbuild'

include Rockbuild

class TestPackage < Minitest::Test
  def setup
    @package = Package.new("1.0", nil)
  end

  def test_has_empty_patches
    assert_empty @package.patches
  end
end
