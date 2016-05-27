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

# Upgrading

## From 1.0 to 2.0

- Roles now have an `order` attribute. Reseed the database to use the predefined values

```
$ rake db:seed
```

- Permission groups and emails are now strongly coupled. Any missing groups can be fixed by running the following task:

```
$ rake db:fix_permission_groups
```

## From 2.0 to 2.1

- Bower is now used for frontend assets. Install it using NPM

```
$ npm install -g bower
```

# Testing

```
$ rake db:create RAILS_ENV=test
$ rake db:migrate RAILS_ENV=test
$ rake db:fixtures:load RAILS_ENV=test

$ rake test RAILS_ENV=test
```

# Configuration

Move, copy or symlink the following files to their production counterpart:

- `config/database.yml.example`
- `config/ldap.yml.example`
- `config/secrets.yml.example`
- `config/mailer.yml.example`

# Run

Capistrano is used to deploy.
To run manually, execute the following command

```
$ RAILS_ENV=production bundle exec rails server # Rails server
```
