source 'https://rubygems.org'

# Bower
gem 'bower-rails', '~> 0.10.0'
# Paper Trail auditing
gem 'paper_trail', '~> 4.0.0'
# Devise authentication
gem 'devise'
# CanCanCan authorization
gem 'cancancan', '~> 1.10'
# LDAP server
gem 'ruby-ldapserver', :git => 'https://github.com/floriandejonckheere/ruby-ldapserver.git'
# Notify exceptions
gem 'exception_notification'

gem 'rails', '4.2.2'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Sidekiq
gem 'sidekiq'

# Puma application server
gem 'puma'

group :development, :test do
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Ensure clean database
  gem 'database_cleaner'

  # Ignore assets logger
  gem 'quiet_assets'

  # Use Capistrano for deployment
  gem 'capistrano', '~> 3.4.0'
  gem 'capistrano-rails', '~> 1.1'
  gem 'capistrano-bundler', '~> 1.1.2'
  gem 'capistrano-rvm'
  gem 'capistrano-upload-config'
  gem 'capistrano3-puma'
end

group :production do
  gem 'pg'
end
