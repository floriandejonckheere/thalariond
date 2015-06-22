require 'ldap/server'
require 'ldap/server/util'

require 'ldapserver/dn'

require 'cancan'

module LDAPServer
  class Operation < LDAP::Server::Operation

    def to_account(dn)
      dn = DN.new(dn)
      if dn.find_one(:ou) == 'users'
        return User.find_by(uid: dn.find_one(:uid))
      else
        return Service.find_by(uid: dn.find_one(:uid))
      end
    end

    def simple_bind(version, bind_dn, password)
      bind_dn.downcase! if bind_dn

      # Authentication is required
      if not bind_dn or not bind_dn.end_with?(Rails.application.config.ldap['base_dn'])
        raise LDAP::ResultError::InvalidCredentials, "Invalid credentials"
      end

      dn = DN.new(bind_dn)
      # Bind DN is "uid=UID,ou=users|services,BASE_DN"
      raise LDAP::ResultError::InvalidCredentials, "Invalid credentials" if dn.find_one(:uid).nil?
      raise LDAP::ResultError::InvalidCredentials, "Invalid credentials" if dn.find_one(:ou).nil?
      raise LDAP::ResultError::InvalidCredentials, "Invalid credentials" unless ['users', 'services'].include?(dn.find_one(:ou))
      raise LDAP::ResultError::InvalidCredentials, "Invalid credentials" unless password

      account = to_account(bind_dn)
      raise LDAP::ResultError::InvalidCredentials, "Invalid credentials" if account.blank?
      raise LDAP::ResultError::InvalidCredentials, "Invalid credentials" unless account.valid_password?(password)
    end

    def search(basedn, scope, deref, filter)
      basedn.downcase!

      raise LDAP::ResultError::InappropriateAuthentication, "Anonymous bind not allowed" if LDAP::Server::Operation.anonymous?
      raise LDAP::ResultError::UnwillingToPerform, "Invalid base DN" unless basedn.end_with?(Rails.application.config.ldap['base_dn'])

      dn = DN.new(basedn)
      raise LDAP::ResultError::UnwillingToPerform, "Invalid base DN" if dn.find_one(:ou).nil?
      raise LDAP::ResultError::UnwillingToPerform, "Invalid base DN" unless ['users', 'groups'].include?(dn.find_one(:ou))

      account = to_account(@connection.binddn)
      ability = Ability.new(account)

      if dn.find_one(:ou) == 'users'
        User.all.each do |u|
          if ability.can? :read, u
            result = []

            if filter[0] == :eq
              result << u if u.attributes[filter[1]] == filter[3]
            elsif filter[0] == :substrings
              result << u if u.attributes[filter[1]] =~ /^#{filter.drop(3).join('.*')}$/
            else
              result << u
            end

            result.each do |r|
              send_SearchResultEntry("uid=#{u.uid},#{basedn}", r.to_ldap)
            end
          end
        end
      elsif dn.find_one(:ou) == 'groups'
        result = []
        if dn.find(:dc).length > 2
          # Search for groups
          domain = dn.find(:dc)
          # Group search needs at least four components: two for the base DN, two for the group domain
          return if domain.length < 4
          if dn.starts_with?("dc=#{domain[0]},dc=#{domain[1]}")
            # Domain search
            Group.where("LOWER(name) LIKE LOWER('%@#{domain[0] + "." + domain[1]}')").each { |g| result << g }
          elsif dn.starts_with?("cn=#{dn.find_one(:cn)}")
            # User search
            group = Group.find_by(name: "#{dn.find_one(:cn)}@#{domain[0]}.#{domain[1]}")
            result << group if group
          end
        else
          # List all groups
          Group.all.each do |g|
            if ability.can? :read, g
              if filter[0] == :eq
                result << g if g.attributes[filter[1]] == filter[3]
              elsif filter[0] == :substrings
                result << g if g.attributes[filter[1]] =~ /^#{filter.drop(3).join('.*')}$/
              else
                result << g
              end
            end
          end
        end
        result.each do |r|
          h = r.to_ldap
          if r.owner != account
            h.delete('member')
          end
          send_SearchResultEntry("cn=#{r.name},#{basedn}", h)
        end
      end

    end
  end
end
