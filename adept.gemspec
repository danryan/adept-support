# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'adept/version'

Gem::Specification.new do |gem|
  gem.name          = "adept"
  gem.version       = Adept::VERSION
  gem.authors       = ["Dan Ryan"]
  gem.email         = ["scriptfu@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "grit", "~> 2.5.0"
  gem.add_dependency "mixlib-shellout", "~> 1.1.0"
  gem.add_dependency "sinatra-contrib"
end
