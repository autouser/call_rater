# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'call_rater/version'

Gem::Specification.new do |spec|
  spec.name          = "call_rater"
  spec.version       = CallRater::VERSION
  spec.authors       = ["Evgeny Grep"]
  spec.email         = ["gyorms@gmail.com"]
  spec.description   = %q{Simple telephone call rater}
  spec.summary       = %q{Simple telephone call rater}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_dependency "activerecord", "~> 4.0"
  spec.add_dependency "mysql2"
  spec.add_dependency "database_cleaner"
  spec.add_dependency "thor"
end
