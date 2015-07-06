#!/bin/bash

# Create a file `private.sh` in `private/`, and define the variables in the run command:
. private/private.sh

docker run -d --name thalariond \
	--link postgresql:postgresql \
	-e "DB_HOST=${DB_HOST}" \
	-e "DB_DATABASE=${DB_DATABASE}" \
	-e "DB_USER=${DB_USER}" \
	-e "DB_PASS=${DB_PASS}" \
	-e "SECRET_KEY_BASE=${SECRET_KEY_BASE}" \
	-e "RAILS_ENV=production" \
	-e "RAILS_SERVE_STATIC_FILES=true" \
	-e "MAILER_HOST=${MAILER_HOST}" \
	-e "MAILER_PORT=${MAILER_PORT}" \
	-e "MAILER_DOMAIN=${MAILER_DOMAIN}" \
	-e "MAILER_USERNAME=${MAILER_USERNAME}" \
	-e "MAILER_PASSWORD=${MAILER_PASSWORD}" \
	-e "MAILER_AUTHENTICATION=${MAILER_AUTHENTICATION}" \
	-e "MAILER_STARTTLS=${MAILER_STARTTLS}" \
	--dns=172.17.42.1 \
	--hostname=thalariond.services.thalarion.be \
	thalarion/thalariond:latest
