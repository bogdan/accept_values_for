# encoding: utf-8

require_relative 'lib/accept_values_for/version'

Gem::Specification.new do |spec|
  spec.name    = "accept_values_for"
  spec.version = AcceptValuesFor::VERSION

  spec.author      = "Bogdan Gusiev"
  spec.email       = "agresso@gmail.com"
  spec.homepage    = "https://github.com/bogdan/accept_values_for"
  spec.license     = "MIT"
  spec.summary     = "Test complex Active Record validations with RSpec"
  spec.description = <<-DESC.gsub(/(^\s+|\n)/, "")
    Writing specs for complex validations is annoying. AcceptValuesFor makes it
    easy to test your validations with real world values, asserting which values
    should be accepted by your model and which should not.
    DESC

  spec.files      = `git ls-files -z`.split("\x0")
  spec.test_files = spec.files.grep(/^spec/)

  spec.required_ruby_version = Gem::Requirement.new(">= 3.0.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  spec.add_dependency "activemodel", ">= 6.1", "< 8.1"
  spec.add_dependency "rspec", ">= 3.10", "< 4.0"

  spec.add_development_dependency "bundler", "~> 2.2"
  spec.add_development_dependency "rake", "~> 13.0"
end
