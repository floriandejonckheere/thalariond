# thalariond

**WARNING**: This project is a work in progress, and may destroy your data and eat your cat.

Thalariond is a suite of services that offers a flexible solution for centralized user management. It features a central administration panel with the ability to define users and services. As underlying service a Ruby LDAP server is bootstrapped to provide access to the user directory for enterprise services.
A permission model is implemented using role-based access control.


## Configuration

Copy `thalariond.env.example` to `thalariond.prod.env` and `thalariond.dev.env`. Edit the two files and use the following commands to use `thalariond.dev.env` outside the Docker container.

```
$ set -a                    # set allexport
$ . ./thalariond.dev.env    # source .env
```


## Installation

### Prerequisites

- RVM
- NPM

### Development

```
$ rvm install $(cat .ruby-version)
$ rvm gemset create $(cat .ruby-gemset)
$ rvm use $(cat .ruby-version)@$(cat .ruby-gemset)
$ gem install bundler
$ bundle install --with development
$ npm install bower
$ rails bower:install
$ rails db:create       # Create database
$ rails db:migrate      # Create tables
$ rails db:seed         # Create roles
$ rails db:create_admin # Create admin account
```

A default `admin` user is created with password `abcd1234`. Additional roles and users are defined in `db/seeds.rb`.

Optionally:

```
$ sudo systemctl start redis
$ gem install mailcatcher
$ bundle exec mailcatcher
$ bundle exec rails server
```

### Production

Docker and docker-compose are used in the deployment process. Use the following command to build and run the necessary containers. The environment variables `$SKIP_MIGRATE` and `$SKIP_PRECOMPILE` can be used to skip migrations and asset precompilation respectively.
 
```
$ docker-compose -f docker-compose.yml -f docker-compose.prod.yml up
```

Data volumes (PostgreSQL, Neo4j, Redis, Musicbrainz) are persisted to disk using Docker volumes. Don't forget to create a read-only PostgreSQL account for the Musicbrainz database.

### Redeployment

```
$ docker-compose up --no-deps -d app
```

### Testing

```
$ rake db:create RAILS_ENV=test
$ rake db:migrate RAILS_ENV=test
$ rake db:fixtures:load RAILS_ENV=test

$ rake test RAILS_ENV=test
```

## Upgrading

### From 1.0 to 2.0

- Roles now have an `order` attribute. Reseed the database to use the predefined values

```
$ rake db:seed
```

- Permission groups and emails are now strongly coupled. Any missing groups can be fixed by running the following task:

```
$ rake db:fix_permission_groups
```

### From 2.0 to 2.1

- Bower is now used for frontend assets. Install it using NPM

```
$ npm install -g bower
```
