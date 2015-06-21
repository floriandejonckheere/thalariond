require 'ldap/server'
require 'ldap/server/util'

require 'ldapserver/dn'

require 'cancan'

module LDAPServer
  class Operation < LDAP::Server::Operation

    def to_account(dn)
      dn = DN.split(dn)
      if dn[:ou] == 'users'
        return User.find_by(uid: dn[:uid])
      else
        return Service.find_by(uid: dn[:uid])
      end
    end

    def simple_bind(version, bind_dn, password)
      bind_dn.downcase! if bind_dn

      # Authentication is required
      if not bind_dn or not bind_dn.end_with?(Rails.application.config.ldap['base_dn'])
        raise LDAP::ResultError::InvalidCredentials, "Invalid credentials"
      end

      dn = DN.split(bind_dn)
      # Bind DN is "uid=UID,ou=users|services,BASE_DN"
      raise LDAP::ResultError::InvalidCredentials, "Invalid credentials" if dn[:uid].nil?
      raise LDAP::ResultError::InvalidCredentials, "Invalid credentials" if dn[:ou].nil?
      raise LDAP::ResultError::InvalidCredentials, "Invalid credentials" unless ['users', 'services'].include?(dn[:ou])
      raise LDAP::ResultError::InvalidCredentials, "Invalid credentials" unless password

      account = to_account(bind_dn)
      raise LDAP::ResultError::InvalidCredentials, "Invalid credentials" if account.blank?
      raise LDAP::ResultError::InvalidCredentials, "Invalid credentials" unless account.valid_password?(password)
    end

    def search(basedn, scope, deref, filter)
      basedn.downcase!

      raise LDAP::ResultError::InappropriateAuthentication, "Anonymous bind not allowed" if LDAP::Server::Operation.anonymous?
      raise LDAP::ResultError::UnwillingToPerform, "Invalid base DN" unless basedn.end_with?(Rails.application.config.ldap['base_dn'])

      dn = DN.split(basedn)
      raise LDAP::ResultError::UnwillingToPerform, "Invalid base DN" if dn[:ou].nil?
      raise LDAP::ResultError::UnwillingToPerform, "Invalid base DN" unless ['users', 'groups'].include?(dn[:ou])

      account = to_account(@connection.binddn)
      ability = Ability.new(account)

      if dn[:ou] == 'users'
        User.all.each do |u|
          if ability.can? :read, u
            send_SearchResultEntry("uid=#{u.uid},#{basedn}", u.to_ldap)
          end
        end
      else
        Group.all.each do |g|
          if ability.can? :read, g
            h = g.to_ldap
            if g.owner != account
              h.delete('member')
            end
            send_SearchResultEntry("cn=#{g.name},#{basedn}", h)
          end
        end
      end

    end
  end
end
