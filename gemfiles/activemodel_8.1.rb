source "https://rubygems.org"

gemspec path: ".."

gem "activemodel", ">= 8.1.0.rc1", "< 8.2"

group :test do
  gem "activerecord", ">= 8.1.0.rc1", "< 8.2", require: "active_record"
  gem "rspec", "~> 3.13"
  gem "sqlite3", "~> 2.2"
end
