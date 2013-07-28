source 'https://rubygems.org'

rails_version = ENV['RAILS_VERSION'] || 'default'

rails = case rails_version
when 'master'
  { :github => 'rails/rails'}
when "default"
  '~> 3.2.0'
else
  "~> #{rails_version}"
end

gem 'activemodel', rails

group :development, :test do
  gem 'rspec', '>=0'
  gem 'rails', rails
  gem 'rspec-rails', '>=2.0.0'
  gem 'jeweler'
  gem 'sqlite3-ruby'
end
