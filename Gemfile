source 'https://rubygems.org'

ruby '~> 2.6'

# Bower assets pipeline integration
gem 'bower-rails'
# Devise authentication
gem 'devise'
# Role-based authorization framework
gem 'cancancan'

gem 'rails', '5.2.2'
# Use SCSS for stylesheets
gem 'sassc-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Progressbar
gem 'nprogress-rails'
# Fix turbolink's jQuery support
gem 'jquery-turbolinks'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Sidekiq
gem 'sidekiq'

# Puma application server
gem 'puma'

group :development, :test do
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'

  # Enforce code style using Rubocop
  gem 'rubocop', :require => false
  gem 'rubocop-rspec', :require => false

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Ensure clean database
  gem 'database_cleaner'
end

group :production do
  gem 'pg'

  # Dummy database for asset precompilation
  gem 'activerecord-nulldb-adapter', :git => 'https://github.com/nulldb/nulldb.git'

  # Notify exceptions
  gem 'exception_notification'
end
