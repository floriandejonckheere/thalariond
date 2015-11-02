# LDAP Architecture

The base dn is specified in `config/ldap.yml`. The directory structure is as following:
```
                              dc=be
                                |
                           dc=thalarion
                                |
              +-----------+-----------+-------------+
              |           |           |             |
         ou=Groups   ou=Services   ou=Users      ou=Mail
              |           |           |             |
       +------------+    ...         ...      +-----------+
       |            |                         |           |
    cn=groupA      ...                  dc=example.com   ...
                                              |
                                          mail=user

```
Every access to the LDAP database must be authenticated using a simple bind. Anonymous bind is not supported. Binding is supported for the trees `ou=Services`, `ou=Users` and `ou=Mail`. The first two map directly onto their ActiveModel counterparts, the latter uses the given password to find a User or Service in an email permission group.

All subtrees can be queried.

## Users

Perform a search with base DN `ou=Users,dc=thalarion,dc=be` to list all accessible users. Scope is ignored. All user attributes can be used for filtering, but currently multiple filter conditions are not supported.
The results are of the following structure, empty attributes will be ommitted.

```
dn: uid=user,ou=Users,dc=thalarion,dc=be
uid: user
givenName: Administrator
sn: Administrator
mail: admin@example.com
enabled: true
```

## Services

Analogous to `ou=Users`, this subtree is used for services. By default, all services are readable by everyone (see `app/models/ability.rb`).

```
dn: uid=service,ou=Services,dc=thalarion,dc=be
uid: service
displayName: Service
enabled: true
```

## Groups

Perform a search with base DN `ou=Groups,dc=thalarion,dc=be` to list all owned and participated groups. Scope is ignored. All attributes can be used for filtering, but currently multiple filter conditions are not supported. The `member` attribute(s) are only visible if the user has the appropriate permissions (owner of group or higher privileged user). The owner is always listed in both the `owner` and the `member` attributes. Members include users who have access to the group and services which operate on the group (for example Postfix and Dovecot will have access to email groups).
The results are of the following format:

```
dn: cn=group,ou=Groups,dc=thalarion,dc=be
cn: group
objectClass: group
displayName: Group
owner: uid=administrator,ou=Users,dc=thalarion,dc=be
member: uid=administrator,ou=Users,dc=thalarion,dc=be
member: uid=postfix,ou=Services,dc=thalarion,dc=be

```

Groups with a name that corresponds to a managed email address are called *permission groups*, and are used to determine the set of users that have access to the email at this address. All participating users can use their own password to login to the mailserver. Permission groups are automatically created upon creation of emails.

## Mail

Perform a search with base DN `ou=Mail,dc=thalarion,dc=be` to list all accessible managed domains and aliases. Scope is ignored. Only the `dc` attribute can be used for filtering, because it is the only data attribute. Multiple filter conditions are not supported. The DN of managed domain is not split into separate `domainComponent`s.

The results are of the following format:

```
dn: dc=mydomain.com,ou=Mail,dc=thalarion,dc=be
objectClass: vmailDomain
dc: mydomain.com

dn: dc=aliasdomain.com,ou=Mail,dc=thalarion,dc=be
objectClass: vmailDomainAlias
alias: aliasdomain.com
dc: mydomain.com
```

Perform a search with base DN `dc=mydomain.com,ou=Mail,dc=thalarion,dc=be` to list all accessible vmails and aliases of the managed domain. Scope is ignored. Only the `mail` attribute (the part before the '@') can be used for filtering. Multiple filter conditions are not supported.

```
dn: mail=admin,dc=mydomain.com,ou=Mail,dc=thalarion,dc=be
objectClass: vmail
mail: admin

dn: mail=aliasmail,dc=mydomain.com,ou=Mail,dc=thalarion,dc=be
objectClass: vmailAlias
alias: aliasmail
mail: admin
```

To support templated dovecot authentication binds, a client can bind against `mail=mymail,dc=mydomain.com,ou=Mail,dc=thalarion,dc=be`. In this mode, the provided password is checked against the passwords of all users in the permission group.

The results are of the following format:

```
dn: mail=admin,dc=mydomain.com,ou=Mail,dc=thalarion,dc=be
mail: admin

```
