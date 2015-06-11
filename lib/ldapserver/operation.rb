require 'ldap/server'
require 'ldap/server/util'

require 'cancan'

module LDAPServer
  class Operation < LDAP::Server::Operation

    def to_account(dn)
      split_dn = LDAP::Server::Operation.split_dn(dn)
      ou_object = split_dn.find { |f| f.has_key?('ou') }
      uid_object = split_dn.find { |f| f.has_key?('uid') }
      if ou_object['ou'] == 'users'
        model = User
      else
        model = Service
      end
      return model.find_by(uid: uid_object['uid'])
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

      account = to_account(dn)
      raise LDAP::ResultError::InvalidCredentials, "Invalid credentials" if account.blank?
      raise LDAP::ResultError::InvalidCredentials, "Invalid credentials" unless account.valid_password?(password)
    end

    def search(basedn, scope, deref, filter)
      basedn.downcase!

      raise LDAP::ResultError::InappropriateAuthentication, "Anonymous bind not allowed" if LDAP::Server::Operation.anonymous?
      raise LDAP::ResultError::UnwillingToPerform, "Invalid base DN" unless basedn.end_with?(Rails.application.config.ldap['base_dn'])
      split_dn = LDAP::Server::Operation.split_dn(basedn)
      raise LDAP::ResultError::UnwillingToPerform, "Invalid base DN" unless split_dn[0].has_key?('ou')
      raise LDAP::ResultError::UnwillingToPerform, "Invalid base DN" unless ['users', 'services'].include?(split_dn[0]['ou'])

      if split_dn[0]['ou'] == 'users'
        model = User
      else
        model = Service
      end

      account = to_account(@connection.binddn)
      ability = Ability.new(account)
      result = []
      model.all.each do |m|
        result << m if ability.can? :read, m
      end
      result = result.map { |m| { :uid => m.uid } }
      p result

      return result

    end
  end
end
