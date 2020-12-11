# encoding: utf-8

Gem::Specification.new do |spec|
  spec.name    = "accept_values_for"
  spec.version = "0.9.0"

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

  spec.add_dependency "activemodel", ">= 5.0", "< 6.2"
  spec.add_dependency "rspec", ">= 3.0", "< 4.0"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 12.3"
end
