require 'minitest/autorun'
require 'rockbuild'
require_relative '../projects/demo_project'
include Rockbuild

class TestCommands < Minitest::Test

  def test_using_string_key_changes_settings
    dry_run_val = false
    Env.with_settings ({"dry_run" => true }) { dry_run_val = Env.dry_run? }
    assert dry_run_val
  end
end
