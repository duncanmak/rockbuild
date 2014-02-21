require 'minitest/autorun'
require 'rockbuild'
require_relative '../projects/demo_project'

cwd = File.expand_path('../', __FILE__)
Dir["#{cwd}/../packages/**/*.rb"].each { |pkg| require pkg }
Dir["#{cwd}/../lib/rockbuild/**/*.rb"].each { |pkg| require pkg }

include Rockbuild

class TestProject < Minitest::Test
  def test_empty_project_has_no_components
    assert_empty Project.new.components
  end

  def test_dry_run_creates_no_dir
    refute File.exists?(Env.build_root)
    Env.with_settings ({dry_run: true, quiet: true }) { DemoProject.new.start }
    refute File.exists?(Env.build_root)
  end
end
