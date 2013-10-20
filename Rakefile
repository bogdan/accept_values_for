require 'rubygems'
require "bundler"
Bundler.setup

require 'rake'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec) do |spec|
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "accept_values_for"
    gemspec.summary = "In order to test a complex validation for ActiveRecord models Implemented accept_values_for custom rspec matcher"
    gemspec.description = <<-EOI
Rspec: When you have a complex validation(e.g. regexp or custom method) on ActiveRecord model
you have to write annoying easy specs on which values should be accepted by your validation method and which should not.
accepts_values_for rspec matcher simplify the code. See example for more information.
EOI
    gemspec.email = "agresso@gmail.com"
    gemspec.homepage = "http://github.com/bogdan/accept_values_for"
    gemspec.authors = ["Bogdan Gusiev"]
    #gemspec.add_dependency "activerecord"
    #gemspec.add_dependency "rspec"
  end
  Jeweler::RubygemsDotOrgTasks.new 
rescue LoadError
  puts "Jeweler not available. Install it with: [sudo] gem install jeweler"
end

task :default => :spec
