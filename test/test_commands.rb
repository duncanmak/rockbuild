require 'minitest/autorun'
require 'rockbuild'
require_relative '../projects/demo_project'
include Rockbuild

class TestCommands < Minitest::Test
  include Commands

  def test_chdir_changes_dir
    cur_dir = Dir.pwd
    new_dir = nil
    Env.with_settings ({dry_run: false }) { chdir("..") { new_dir = Dir.pwd } }
    refute_nil new_dir
    refute_equal cur_dir, new_dir
  end

  def test_chdir_doesnt_change_dir_in_dryrun_mode
    cur_dir = Dir.pwd
    new_dir = nil
    Env.with_settings ({dry_run: true }) { chdir("..") { new_dir = Dir.pwd } }
    refute_nil new_dir
    assert_equal cur_dir, new_dir
  end
end
