#!/bin/sh
#
# docker-entrypoint.sh - Start server
#

cd /app

[[ ${SKIP_MIGRATE} ]] || bundle exec rake db:migrate            # Migrate relational data
[[ ${SKIP_MIGRATE} ]] || bundle exec rake db:data:migrate       # Migrate graph data
[[ ${SKIP_PRECOMPILE} ]] || bundle exec rake assets:precompile  # Precompile assets
bundle exec rails server -p 8080        # Start puma
