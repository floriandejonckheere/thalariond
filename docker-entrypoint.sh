#!/bin/bash
#
# docker-entrypoint.sh - Start server
#

cd /app

[[ ${SKIP_MIGRATE} ]] || bundle exec rake db:migrate            # Migrate relational data
bundle exec rails server -p 8080        # Start puma
