require 'minitest/autorun'
require 'rockbuild'

include Rockbuild

class TestPackage < Minitest::Test
  def setup
    profile = DemoProfile.new
    @package = Package.new(profile)
  end

  def test_has_empty_patches
    assert_empty @package.patches
  end
end
