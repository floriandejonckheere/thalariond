#!/bin/bash
#
# docker-entrypoint.sh - Start server
#

# Correct permissions
chown -R thalariond:thalariond /app/

# Remove stale lock files
rm -f /app/tmp/pids/server.pid

# Run as regular user
su - thalariond

# Migrate relational data
[[ ${SKIP_MIGRATE} ]] || bundle exec rake db:migrate

# Start app server
bundle exec puma -b unix:///app/tmp/sockets/puma.sock
