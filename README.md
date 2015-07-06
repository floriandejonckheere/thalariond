# thalariond

**WARNING**: This project is a work in progress, and may destroy your data and eat your cat.

Thalariond is a suite of services that offers a flexible solution for centralized user management. It features a central administration panel with the ability to define users and services. As underlying service a Ruby LDAP server is bootstrapped to provide access to the user directory for enterprise services.

# Installation

```
$ bundle install
$ rake db:setup # Creates and seed the initial database
```

A default `admin` user is created with password `abcd1234`. Additional roles and users are created in `db/seed.rb`.

# Configuration

# Run

To run manually, execute the following commands
```
$ RAILS_ENV=production lib/daemons/ldapd_ctl start # LDAP server
$ RAILS_ENV=production rails server # Rails server
```

Or use the Dockerfile.
**WARNING**: By default no database migrations are ever applied. Apply them manually after each update!
