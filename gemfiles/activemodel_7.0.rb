source "https://rubygems.org"

gemspec path: ".."

gem "activemodel", "~> 7.0.0"
gem "bigdecimal"
gem "logger"
gem "mutex_m"

group :test do
  gem "activerecord", "~> 7.0.0", require: "active_record"
  gem "rspec", "~> 3.10"
  gem "sqlite3", "~> 1.4"
end
