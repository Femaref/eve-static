# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'eve_static/version'

Gem::Specification.new do |gem|
  gem.name          = "eve_static"
  gem.version       = EveStatic::VERSION
  gem.authors       = ["Femaref"]
  gem.email         = ["femaref@googlemail.com"]
  gem.description   = %q{EveStatic is a gem designed to access the eve online static database dump, and provides conveinience methods, especially for industry calculations.}
  gem.summary       = %q{EveStatic: Library to access eve online static database}
  gem.homepage      = "https://github.com/Femaref/eve-static"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
