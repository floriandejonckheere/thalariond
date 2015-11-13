require 'cancan'

module LDAPd
class LDAPController

  ###############
  ### Binding ###
  ###############

  def self.bindUser(request, version, dn, password, params)
    dn.downcase!

    raise LDAP::ResultError::InvalidCredentials if params[:uid].nil?
    raise LDAP::ResultError::InvalidCredentials if password.nil?
    user = User.find_by(:uid => params[:uid])
    raise LDAP::ResultError::InvalidCredentials if user.nil?
    raise LDAP::ResultError::InvalidCredentials if not user.valid_password? password
    request.connection.account = user
  end

  def self.bindService(request, version, dn, password, params)
    dn.downcase!

    raise LDAP::ResultError::InvalidCredentials if params[:uid].nil?
    raise LDAP::ResultError::InvalidCredentials if password.nil?
    service = Service.find_by(:uid => params[:uid])
    raise LDAP::ResultError::InvalidCredentials if service.nil?
    raise LDAP::ResultError::InvalidCredentials if not service.valid_password? password
    request.connection.account = service
  end

  def self.bindMail(request, version, dn, password, params)
    dn.downcase!

    raise LDAP::ResultError::InvalidCredentials if params[:mail].nil?
    raise LDAP::ResultError::InvalidCredentials if params[:domain].nil?
    raise LDAP::ResultError::InvalidCredentials if password.nil?
    domain = Domain.find_by(:domain => params[:domain])
    raise LDAP::ResultError::InvalidCredentials if domain.nil?
    email = domain.emails.find_by(:mail => params[:mail])
    raise LDAP::ResultError::InvalidCredentials if email.nil?
    group = email.group
    raise LDAP::ResultError::InvalidCredentials if group.nil?

    group.users.each do |user|
      if user.valid_password? password
        request.connection.account = user
        return
      end
    end
    group.services.each do |service|
      if service.valid_password? password
        request.connection.account = service
        return
      end
    end
    raise LDAP::ResultError::InvalidCredentials
  end

  def self.bindGroup(request, version, dn, password, params)
    dn.downcase!

    raise LDAP::ResultError::InvalidCredentials if params[:cn].nil?
    raise LDAP::ResultError::InvalidCredentials if password.nil?
    group = Group.find_by(:name => params[:cn])
    raise LDAP::ResultError::InvalidCredentials if group.nil?

    group.users.each do |user|
      if user.valid_password? password
        request.connection.account = user
        return
      end
    end
    group.services.each do |service|
      if service.valid_password? password
        request.connection.account = service
        return
      end
    end
    raise LDAP::ResultError::InvalidCredentials
  end


  #################
  ### Searching ###
  #################

  def self.searchUser(request, baseObject, scope, deref, filter, params)
    baseObject.downcase!

    raise LDAP::ResultError::InappropriateAuthentication, "Anonymous bind not allowed" if request.connection.account.nil?

    User.all.each do |user|
      next if request.connection.account.cannot? :read, user
      user_hash = user.to_ldap

      user_hash.delete 'group' if request.connection.account.cannot? :update, user

      result = LDAP::Server::Filter.run(filter, user_hash)
      request.send_SearchResultEntry("uid=#{user_hash['uid']},#{baseObject}", user_hash) if result
    end
  end

  def self.searchService(request, baseObject, scope, deref, filter, params)
    baseObject.downcase!

    raise LDAP::ResultError::InappropriateAuthentication, "Anonymous bind not allowed" if request.connection.account.nil?

    Service.all.each do |service|
      next if request.connection.account.cannot? :read, service
      service_hash = service.to_ldap

      service_hash.delete 'group' if request.connection.account.cannot? :update, service

      result = LDAP::Server::Filter.run(filter, service_hash)
      request.send_SearchResultEntry("uid=#{service_hash['uid']},#{baseObject}", service_hash) if result
    end
  end

  def self.searchGroup(request, baseObject, scope, deref, filter, params)
    baseObject.downcase!

    raise LDAP::ResultError::InappropriateAuthentication, "Anonymous bind not allowed" if request.connection.account.nil?

    Group.accessible_by(request.connection.ability).each do |group|
      group_hash = group.to_ldap
      p group_hash
      result = LDAP::Server::Filter.run(filter, group_hash)
      request.send_SearchResultEntry("cn=#{group_hash['cn']},#{baseObject}", group_hash) if result
    end
  end

  def self.searchDomain(request, baseObject, scope, deref, filter, params)
    baseObject.downcase!

    raise LDAP::ResultError::InappropriateAuthentication, "Anonymous bind not allowed" if request.connection.account.nil?

    Domain.accessible_by(request.connection.ability).each do |domain|
      domain_hash = domain.to_ldap

      result = LDAP::Server::Filter.run(filter, domain_hash)
      request.send_SearchResultEntry("dc=#{domain_hash['dc']},#{baseObject}", domain_hash) if result
    end
    DomainAlias.accessible_by(request.connection.ability).each do |domain_alias|
      domain_alias_hash = domain_alias.to_ldap

      result = LDAP::Server::Filter.run(filter, domain_alias_hash)
      request.send_SearchResultEntry("alias=#{domain_alias_hash['alias']},#{baseObject}", domain_alias_hash) if result
    end
  end

  def self.searchMail(request, baseObject, scope, deref, filter, params)
    baseObject.downcase!

    raise LDAP::ResultError::InappropriateAuthentication, "Anonymous bind not allowed" if request.connection.account.nil?

    domain = Domain.find_by(:domain => params[:domain])
    if domain
      domain.emails.each do |email|
        next if request.connection.account.cannot? :read, email
        email_hash = email.to_ldap

        result = LDAP::Server::Filter.run(filter, email_hash)
        request.send_SearchResultEntry("mail=#{email_hash['mail']},#{baseObject}", email_hash) if result
      end
      EmailAlias.select { |ea| ea.alias.split('@').last == params[:domain] }.each do |email_alias|
        next if request.connection.account.cannot? :read, email_alias
        email_alias_hash = email_alias.to_ldap

        result = LDAP::Server::Filter.run(filter, email_alias_hash)
        request.send_SearchResultEntry("alias=#{email_alias_hash['alias']},#{baseObject}", email_alias_hash) if result
      end
    end
  end

end
end
