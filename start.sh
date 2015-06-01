#!/bin/bash

rake db:migrate RAILS_ENV=production
rails server -b 0.0.0.0 -e production
