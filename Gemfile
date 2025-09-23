# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in unified_settings.gemspec
gemspec

gem 'bundler', '~> 2.3'
gem 'bundler-audit', '>= 0'
gem 'minitest', '~> 5.0'
gem 'rake', '~> 13.0'
gem 'rubocop', '~> 1.21'
gem 'rubocop-minitest', '>= 0'
gem 'rubocop-performance', '>= 0'
gem 'rubocop-rails', '>= 0'
gem 'rubocop-rake', '>= 0'
gem 'ruby_audit', '>= 0'

##
## Rails App Gemfile contents
##

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 8.0.3'

# The modern asset pipeline for Rails
# https://github.com/rails/propshaft
gem 'propshaft'

# Use the Puma web server
# [https://github.com/puma/puma]
gem 'puma', '~> 6.0'

# Build JSON APIs with ease
# [https://github.com/rails/jbuilder]
# gem 'jbuilder'

# Use Kredis to get higher-level data types in Redis
# [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password
# [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Bundle and process CSS
# https://github.com/rails/cssbundling-rails
gem 'cssbundling-rails'

# Use Sass to process CSS
# gem "sassc-rails"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri mingw x64_mingw]
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  # gem 'web-console'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps
  # [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  # Use system testing
  # [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'webdrivers'
end

#
# Gem that has been added to default Gemfile so that we can run the tests
# for the handlers
#

#
# Add multi-environment yaml settings to rails
# https://github.com/rubyconfig/config
gem 'config', '>= 3.0'
