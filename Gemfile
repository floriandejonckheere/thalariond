source 'https://rubygems.org'

source 'https://rails-assets.org' do
  # Hint
  gem 'rails-assets-hint'
  # Tether used for Bootstrap popovers
  gem 'rails-assets-tether', '>= 1.1.0'
  # Bootstrap Checkbox
  gem 'rails-assets-awesome-bootstrap-checkbox'
end

# Font Awesome
gem 'font-awesome-sass', '~> 4.4.0'
# Bootstrap 4 Alpha
gem 'bootstrap', git: 'https://github.com/twbs/bootstrap-rubygem'
# Bootstrap switch
gem 'bootstrap-switch-rails'
# Paper Trail auditing
gem 'paper_trail', '~> 4.0.0'
# Devise authentication
gem 'devise'
# CanCanCan authorization
gem 'cancancan', '~> 1.10'
# LDAP server
gem 'ruby-ldapserver', :git => 'https://github.com/floriandejonckheere/ruby-ldapserver.git'
# Daemons for LDAP server
gem 'daemons-rails'
# Notify exceptions
gem 'exception_notification'

gem 'rails', '4.2.2'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Puma application server
gem 'puma'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.1.3'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # Ensure clean database
  gem 'database_cleaner'

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
