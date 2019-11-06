# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '~> 2.6'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5'
# Use PostgreSQL as database
gem 'pg'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker', '~> 4.0'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Authentication
gem 'devise'

# Authorization
gem 'pundit'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]

  # Git pre-commit hooks
  gem 'overcommit', require: false

  # Enforce code style using Rubocop
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false

  # Analyze potential speed improvements
  gem 'fasterer', require: false

  # Detect code smells
  gem 'reek', require: false

  # Security vulnerability scanner
  gem 'brakeman', require: false

  # Check for vulnerable versions of gems
  gem 'bundler-audit', require: false
end

group :test do
  # BDD testing for Ruby
  gem 'rspec'
  gem 'rspec-rails'

  # Rails RSpec matchers
  gem 'shoulda-matchers'

  # Pundit RSpec matchers
  gem 'pundit-matchers'

  # Factory pattern for testing
  gem 'factory_bot'
  gem 'factory_bot_rails'

  # Fake data generator
  gem 'ffaker'
end

group :development do
  # Annotate models with database information
  gem 'annotate'

  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end
