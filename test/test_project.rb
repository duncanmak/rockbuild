require 'minitest/autorun'
require 'rockbuild'
require_relative '../projects/demo_project'
include Rockbuild

class TestProject < Minitest::Test
  def test_empty_project_has_no_components
    assert_empty Project.new.components
  end
end
