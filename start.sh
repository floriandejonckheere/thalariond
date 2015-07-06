#!/bin/bash

cd /app

# Compile assets
rake assets:precompile RAILS_ENV=${RAILS_ENV}

# Run application
rm -f /app/tmp/pids/server.pid
rails server -b 0.0.0.0 -e ${RAILS_ENV}
