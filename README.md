# thalariond

**WARNING**: This project is a work in progress, and may destroy your data and eat your cat.

Thalariond is a suite of services that offers a flexible solution for centralized user management. It features a central administration panel with the ability to define users and services. As underlying service a Ruby LDAP server is bootstrapped to provide access to the user directory for enterprise services.
A permission model is implemented using role-based access control.

# Installation

```
$ bundle install
$ rake db:create        # Create database
$ rake db:migrate       # Create tables
$ rake db:seed          # Create roles
$ rake db:create_admin  # Create admin account
```

A default `admin` user is created with password `abcd1234`. Additional roles and users are created in `db/seed.rb`.

# Testing

```
$ rake db:create RAILS_ENV=test
$ rake db:migrate RAILS_ENV=test
$ rake db:fixtures:load RAILS_ENV=test

$ rake test RAILS_ENV=test
```

# Configuration

# Run

To run manually, execute the following commands
```
$ RAILS_ENV=production bundle exec lib/daemons/ldapd_ctl start # LDAP server
$ RAILS_ENV=production bundle exec rails server # Rails server
```

Or use the Dockerfile.
**WARNING**: By default no database migrations are ever applied. Apply them manually after each update!
