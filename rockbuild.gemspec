# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rockbuild/version'

Gem::Specification.new do |spec|
  spec.name          = "rockbuild"
  spec.version       = Rockbuild::VERSION
  spec.authors       = ['Duncan Mak', "Cody Russell"]
  spec.email         = ['duncan@xamarin.com', "cody@xamarin.com"]
  spec.summary       = %q{A little build tool.}
  spec.description   = %q{A little build tool.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.bindir        = 'exe'
  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end
