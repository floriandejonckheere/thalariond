#!/bin/bash

cd /app
export RAILS_ENV=production

# Migrate database
rake db:migrate

# Compile assets
rake assets:precompile

# Run application
./lib/daemons/ldapd_ctl start
rails server -b 0.0.0.0 -e production
