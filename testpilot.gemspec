# -*- encoding: utf-8 -*-
require File.expand_path('../lib/test_pilot/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Ivan Vanderbyl"]
  gem.email         = ["ivan@testpilot.me"]
  gem.description   = %q{TestPilot CI Command Line Interface}
  gem.summary       = %q{A simple CLI for starting builds, debugging build environments, and interactively testing}
  gem.homepage      = "http://testpilot.me"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "testpilot"
  gem.require_paths = ["lib"]
  gem.executables   = 'testpilot'
  gem.version       = TestPilot::VERSION

  gem.add_dependency('thor')
  gem.add_development_dependency('rspec', '~> 2.8.0')
  gem.add_development_dependency('simplecov', '~> 0.5.4')
  gem.add_development_dependency('fakefs', '~> 0.4.0')
  gem.add_development_dependency('webmock', '~> 1.7.10')
end

