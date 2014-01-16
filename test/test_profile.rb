require 'minitest/autorun'
require 'rockbuild'
require_relative '../profiles/demo_profile'

include Rockbuild

class TestProfile < Minitest::Test
  def setup
    @profile = DemoProfile.new
  end

  def test_has_packages
    refute_empty @profile.packages
  end
end
