#!/bin/bash

# Create a file named 'private.sh', and define the following variables:
# DB_DATABASE, DB_USER, DB_PASS, SECRET_KEY_BASE
. private.sh

docker run -d --name thalariond \
	--link postgresql:postgresql \
	-e "DB_DATABASE=${DB_DATABASE}" \
	-e "DB_USER=${DB_USER}" \
	-e "DB_PASS=${DB_PASS}" \
	-e "SECRET_KEY_BASE=${SECRET_KEY_BASE}" \
	-e "RAILS_SERVE_STATIC_FILES=yesplease" \
	thalarion/thalariond:latest
