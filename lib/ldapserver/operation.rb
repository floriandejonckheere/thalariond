require 'ldap/server'
require 'ldap/server/util'

class LDAPServer::Operation < LDAP::Server::Operation
  def authenticate(model, uid, password)
    model.find(uid)
  end

  def simple_bind(version, dn, password)
    dn.downcase! if dn

    # Authentication is required
    if not dn or not dn.end_with?(Rails.application.config.ldap['base_dn'])
      raise LDAP::ResultError::InvalidCredentials, "Invalid credentials"
    end

    split_dn = LDAP::Server::Operation.split_dn(dn)
    # Bind DN is "uid=UID,ou=users|services,BASE_DN"
    raise LDAP::ResultError::InvalidCredentials, "Invalid credentials" unless split_dn[0].has_key?('uid')
    raise LDAP::ResultError::InvalidCredentials, "Invalid credentials" unless split_dn[1].has_key?('ou')
    raise LDAP::ResultError::InvalidCredentials, "Invalid credentials" unless ['users', 'services'].include?(split_dn[1]['ou'])
    raise LDAP::ResultError::InvalidCredentials, "Invalid credentials" unless password

    p UsersController.helpers

    puts "Bound #{split_dn[0]['uid']}"
  end

  def search(basedn, scope, deref, filter)
    basedn.downcase!

    puts LDAP::Server::Operation.anonymous?

    raise LDAP::ResultError::UnwillingToPerform, "Invalid base DN" unless basedn.end_with?(Rails.application.config.ldap['base_dn'])

    puts "Search: basedn=#{basedn.inspect}, scope=#{scope.inspect}, deref=#{deref.inspect}, filter=#{filter.inspect}\n"

    raise LDAP::ResultError::InvalidSyntax, "Invalid search filter" unless filter[0]
  end
end
