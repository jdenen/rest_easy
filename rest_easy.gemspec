# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rest_easy/version'

Gem::Specification.new do |spec|
  spec.name          = "rest_easy"
  spec.version       = RestEasy::VERSION
  spec.authors       = ["Johnson Denen"]
  spec.email         = ["jdenen@manta.com"]
  spec.summary       = %q{Retrieve an API response until it passes a validation or times out.}
  spec.description   = %q{Retrieve an API response until it passes a validation or times out.}
  spec.homepage      = "http://github.com/jdenen/rest_easy"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "rest-client"
  
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end