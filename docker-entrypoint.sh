#!/bin/bash
#
# docker-entrypoint.sh - Start server
#

cd /app

rm -f /app/tmp/pids/server.pid

[[ ${SKIP_MIGRATE} ]] || bundle exec rake db:migrate            # Migrate relational data
bundle exec rails server -p 8080        # Start puma
