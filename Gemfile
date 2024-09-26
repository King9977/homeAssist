source "https://rubygems.org"

gem "rails", "~> 7.2.1"
gem "sprockets-rails"
gem "sqlite3", "~> 1.4"
gem 'bcrypt', '~> 3.1.7'
gem "puma", ">= 5.0"
gem "importmap-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "tzinfo-data", platforms: %i[mswin mingw jruby]
gem "bootsnap", require: false
gem 'pundit'
gem 'paper_trail'

group :development, :test do
  gem "debug", platforms: %i[mri mingw x64_mingw], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem 'mocha', require: false
end
