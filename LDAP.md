# LDAP Architecture

The base dn is specified in `config/ldap.yml`. The directory structure is as following:
```
                dc=be
                  |
             dc=thalarion
                  |
      +-----------+-----------+-----------+
      |           |           |           |
  ou=Users   ou=Services   ou=Groups   ou=Mail
                                          |
                              +-----------+-----------+
                              |           |           |
                             ...    dc=example.com   ...
                                          |
                                      mail=user

```

Authentication is handled by binding using a user or a service (using the appropriate DN). Anonymous binding is not supported. The contents of the `ou=Users` and `ou=Groups` tree is dependant on the role of the bound user. A higher privileged user will see all users, whereas a regular user will only see himself.

Similarly, `ou=Groups` contain the groups the user or service owns or is a member of.

## Users

Perform a search with base DN `ou=Users,dc=thalarion,dc=be` to list all (visible) users. Scope is ignored. All user attributes can be used for filtering, but currently multiple filter conditions are not supported.
The results are of the following structure:

```
dn: uid=user,ou=Users,dc=thalarion,dc=be
givenName: Administrator
sn: Administrator [OPTIONAL]
mail: admin@example.com
enabled: true
```

## Services

The `ou=Services` tree is used only for binding services, and as such is not queryable.

## Groups

Perform a search with base DN `ou=Groups,dc=thalarion,dc=be` to list all owned and participated groups. Scope is ignored. All (visible) attributes can be used for filtering, currently multiple filter conditions are not supported. The `member` attribute(s) are only visible if the user has the appropriate permissions (owner of group or higher privileged user). The owner is both listed in the `owner` and the `member` attributes. Members include users who have access to the group and services which operate on the group (for example Postfix and Dovecot will have access to email groups).
The results are of the following format:

```
dn: cn=group,ou=Groups,dc=thalarion,dc=be
displayName: Group
owner: uid=administrator,ou=Users,dc=thalarion,dc=be
member: owner: uid=administrator,ou=Users,dc=thalarion,dc=be

```

Groups with a name that corresponds to a managed email address are called *permission groups*, and are used to determine the set of users that have access to the email at this address. All participating users can use their own password to login to the IMAP server. Permission groups are automatically created upon creation of emails.

## Mail

Perform a search with base DN `ou=Mail,dc=thalarion,dc=be` to list all managed domains. Scope is ignored. Only the `dc` attribute can be used for filtering, because it is the only data-attribute. Multiple filter conditions are obviously not supported. The DN of managed domain is not split into separate `domainComponent`s.
Perform a search with base DN `dc=mydomain.com,dc=thalarion,dc=be` to list all emails of the managed domain. Scope is ignored. Only the `mail` attribute (the part before the '@') can be used for filtering. Multiple filter conditions are not supported.

To support templated dovecot authentication binds, a client can bind against `mail=mymail,dc=mydomain.com,ou=Mail,dc=thalarion,dc=be`. In this mode, the provided password is checked against the passwords of all users in the permission group.

The results are of the following format:

```
dn: mail=admin,dc=mydomain.com,ou=Domains,dc=thalarion,dc=be
mail: admin

```
