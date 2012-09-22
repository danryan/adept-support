# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'adept/support/version'

Gem::Specification.new do |gem|
  gem.name          = "adept-support"
  gem.version       = Adept::Support::VERSION
  gem.authors       = ["Dan Ryan"]
  gem.email         = ["scriptfu@gmail.com"]
  gem.description   = %q{Support library for Adept}
  gem.summary       = %q{Adept support lib}
  gem.homepage      = "https://github.com/danryan/adept-support"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency "mixlib-shellout", "~> 1.1.0"
end
