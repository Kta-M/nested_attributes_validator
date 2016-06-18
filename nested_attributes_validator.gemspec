# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nested_attributes_validator/version'

Gem::Specification.new do |spec|
  spec.name          = "nested_attributes_validator"
  spec.version       = NestedAttributesValidator::VERSION
  spec.authors       = ["Kta-M"]
  spec.email         = ["mohri1219@gmail.com"]

  spec.summary       = %q{Nested Attributes Validation Collection for Rails}
  spec.description   = %q{Nested Attributes Validation Collection for Rails}
  spec.homepage      = "https://github.com/Kta-M/nested_form_validator"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'activemodel'
  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry-rails"
end
