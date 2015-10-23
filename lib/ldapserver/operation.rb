require 'ldap/server'
require 'ldap/server/dn'

require 'cancan'

module LDAPServer
  class Operation < LDAP::Server::Operation

    def to_account(dn)
      dn = LDAP::Server::DN.new(dn)
      case dn.find_first(:ou)
      when 'users'
        return User.find_by(uid: dn.find_one(:uid))
      when 'service'
        return Service.find_by(uid: dn.find_one(:uid))
      else
        nil
      end
    end

    def simple_bind(version, bind_dn, password)
      bind_dn.downcase! if bind_dn

      basedn = Rails.application.config.ldap['base_dn']

      # Authentication is required
      if not bind_dn or
          not bind_dn.end_with?(Rails.application.config.ldap['base_dn']) or
          not password
        raise LDAP::ResultError::InvalidCredentials, "Invalid credentials"
      end

      dn = LDAP::Server::DN.new(bind_dn)
      if dn.end_with?("ou=users,#{basedn}")
        # Bind user
        raise LDAP::ResultError::InvalidCredentials, "Invalid credentials" if dn.find_first(:uid).nil?
        user = User.find_by(uid: dn.find_first(:uid))
        raise LDAP::ResultError::InvalidCredentials, "Invalid credentials" if (user.nil? or not user.valid_password?(password))
        return true
      elsif dn.end_with?("ou=services,#{basedn}")
        # Bind service
        raise LDAP::ResultError::InvalidCredentials, "Invalid credentials" if dn.find_first(:uid).nil?
        service = Service.find_by(uid: dn.find_first(:uid))
        raise LDAP::ResultError::InvalidCredentials, "Invalid credentials" if (service.nil? or not service.valid_password?(password))
        return true
      elsif dn.end_with?("ou=mail,#{basedn}")
        # Bind email
        raise LDAP::ResultError::UnwillingToPerform, "Invalid bind DN" unless dn.equal_format?("mail=,dc=,ou=Mail,#{basedn}")
        domain = Domain.find_by(domain: dn.find_first(:dc))
        raise LDAP::ResultError::InvalidCredentials, "Invalid credentials" if domain.nil?
        email = domain.emails.find_by(mail: dn.find_first(:mail))
        raise LDAP::ResultError::InvalidCredentials, "Invalid credentials" if email.nil?
        group = Group.find_by(name: "#{email.mail}@#{domain.domain}")
        if group.nil?
          # Email exists, but group doesn't
          @connection.opt[:logger].error "Email #{email} does not have a permission group"
          raise LDAP::ResultError::InvalidCredentials, "Invalid credentials"
        end

        group.users.each do |user|
          return if user.valid_password?(password)
        end
        group.services.each do |service|
          return if service.valid_password?(password)
        end
        raise LDAP::ResultError::InvalidCredentials, "Invalid credentials"
      elsif dn.end_with?("ou=groups,#{Rails.application.config.ldap['base_dn']}")
        # Bind user in group
        raise LDAP::ResultError::UnwillingToPerform, "Invalid bind DN" unless dn.equal_format?("uid=,cn=,ou=Groups,#{basedn}")
        group = Group.find_by(name: dn.find_first(:cn))
        raise LDAP::ResultError::InvalidCredentials, "Invalid credentials" if group.nil?
        user = group.users.find_by(uid: dn.find_first(:uid))
        raise LDAP::ResultError::InvalidCredentials, "Invalid credentials" if (user.nil? or not user.valid_password?(password))
        return true
      else
        raise LDAP::ResultError::UnwillingToPerform, "Invalid bind DN"
      end
    end

    def search(basedn, scope, deref, filter)
      basedn.downcase!

      raise LDAP::ResultError::InappropriateAuthentication, "Anonymous bind not allowed" if LDAP::Server::Operation.anonymous?
      raise LDAP::ResultError::UnwillingToPerform, "Invalid base DN" unless basedn.end_with?(Rails.application.config.ldap['base_dn'])

      dn = LDAP::Server::DN.new(basedn)
      raise LDAP::ResultError::UnwillingToPerform, "Invalid base DN" if dn.find_one(:ou).nil?
      raise LDAP::ResultError::UnwillingToPerform, "Invalid base DN" unless ['users', 'groups', 'domains'].include?(dn.find_one(:ou))

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
      elsif dn.find_one(:ou) == 'services'
        Service.all.each do |s|
          if ability.can? :read, s
            result = []

            if filter[0] == :eq
              result << s if s.attributes[filter[1]] == filter[3]
            elsif filter[0] == :substrings
              result << s if s.attributes[filter[1]] =~ /^#{filter.drop(3).join('.*')}$/
            else
              result << s
            end

            result.each do |r|
              send_SearchResultEntry("uid=#{u.uid},#{basedn}", r.to_ldap)
            end
          end
        end
      elsif dn.find_one(:ou) == 'groups'
        result = []
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
        result.each do |r|
          h = r.to_ldap
          if r.owner != account
            h.delete('member')
          end
          send_SearchResultEntry("cn=#{r.name},#{basedn}", h)
        end
      elsif dn.find_one(:ou) == 'domains'
        if dn.find(:dc).length > 2
          # List emails
          domain = Domain.find_by(domain: dn.find_one(:dc))
          raise LDAP::ResultError::NoSuchObject, "No such domain" if domain.nil?
          raise LDAP::ResultError::InsufficientAccessRights, "Insufficient permissions" unless ability.can? :read, domain
          result = []
          if filter[0] == :eq
            e = domain.emails.find_by(mail: filter[3])
            result << e if e
          elsif filter[0] == :substrings
            domain.emails.each do |e|
              result << e if e.mail =~ /^#{filter.drop(3).join('.*')}$/
            end
          else
            domain.emails.each { |e| result << e }
          end
          result.each do |e|
            send_SearchResultEntry("mail=#{e.mail},#{basedn}", e.to_ldap)
          end
        else
          # List domains
          raise LDAP::ResultError::InsufficientAccessRights, "Insufficient permissions" unless ability.can? :list, Domain
          result = []
          if filter[0] == :eq
            d = Domain.find_by(domain: filter[3])
            result << d if d
          elsif filter[0] == :substrings
            Domain.all.each do |d|
              result << d if d.domain =~ /^#{filter.drop(3).join('.*')}$/
            end
          else
            Domain.all.each { |d| result << d }
          end
          result.each do |d|
            send_SearchResultEntry("dc=#{d.domain},#{basedn}", d.to_ldap)
          end
        end
      end

    end
  end
end
