require 'ldapserver'
include LDAPServer

puts "=> Starting LDAP server"
LDAPServer.start
