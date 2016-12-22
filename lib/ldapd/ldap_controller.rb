require 'cancancan'

module LDAPd
class LDAPController
class << self

  def fail(request, message, error = LDAP::ResultError::InvalidCredentials)
    $stderr << message
    raise error
  end

  ###############
  ### Binding ###
  ###############

  # uid=:uid, ou=services, dc=thalarion, dc=be
  def bindService(request, version, dn, password, params)
    dn.downcase!

    fail request, "bind #{dn} failed: empty uid" if params[:uid].nil? or params[:uid].empty?
    fail request, "bind #{dn} failed: empty password" if password.nil?

    service = Service.find_by :uid => params[:uid]

    fail request, "bind #{dn} failed: invalid uid" if service.nil?
    fail request, "bind #{dn} failed: invalid password" unless service.valid_password? password

    request.connection.account = service
  end

  # mail=:mail, dc=:domain, ou=mail, dc=thalarion, dc=be
  def bindMail(request, version, dn, password, params)
    dn.downcase!

    fail request, "bind #{dn} failed: empty local part" if params[:mail].nil? or params[:mail].empty?
    fail request, "bind #{dn} failed: empty domain" if params[:domain].nil? or params[:domain].empty?
    fail request, "bind #{dn} failed: empty password" if password.nil?

    domain = Domain.find_by :domain => params[:domain]
    fail request, "bind #{dn} failed: invalid domain" if domain.nil?

    email = domain.emails.find_by :mail => params[:mail]
    fail request, "bind #{dn} failed: invalid email" if email.nil?

    # This should never fail
    group = email.group
    fail request, "bind #{dn} failed: email has no permission group" if group.nil?

    group.users.each do |user|
      if user.valid_password? password
        fail request, "bind #{dn} failed: user '#{user.uid}' does not have role 'mail'" unless user.has_role? :mail
        request.connection.account = user
        return
      end
    end
    group.services.each do |service|
      if group.has_role? :mail and service.valid_password? password
        fail request, "bind #{dn} failed: service '#{service.uid}' does not have role 'mail'" unless user.has_role? :mail
        request.connection.account = service
        return
      end
    end

    fail request, "bind #{dn} failed: invalid credentials"
  end

  # uid=:uid, cn=:group, ou=groups, dc=thalarion, dc=be
  def bindGroup(request, version, dn, password, params)
    dn.downcase!

    fail request, "bind #{dn} failed: empty group" if params[:group].nil? or params[:group].empty?
    fail request, "bind #{dn} failed: empty uid" if params[:uid].nil? or params[:uid].empty?
    fail request, "bind #{dn} failed: empty password" if password.nil?

    group = Group.find_by :name => params[:group]
    fail request, "bind #{dn} failed: invalid group" if group.nil?


    account = group.users.find_by(:uid => params[:uid]) || group.services.find_by(:uid => params[:uid])
    fail request, "bind #{dn} failed: invalid uid" if account.nil?
    fail request, "bind #{dn} failed: invalid password" unless account.valid_password? password
  end


  #################
  ### Searching ###
  #################

  # ou=mail, dc=thalarion, dc=be
  def searchDomains(request, baseObject, scope, deref, filter, params)
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

  # dc=:domain, ou=mail, dc=thalarion, dc=be
  def searchDomain(request, baseObject, scope, deref, filter, params)
    baseObject.downcase!

    raise LDAP::ResultError::InappropriateAuthentication, "Anonymous bind not allowed" if request.connection.account.nil?

    domain = Domain.find_by :domain => params[:domain]
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

  # cn=:group, ou=groups, dc=thalarion, dc=be
  def searchGroup(request, baseObject, scope, deref, filter, params)
    baseObject.downcase!

    raise LDAP::ResultError::InappropriateAuthentication, "Anonymous bind not allowed" if request.connection.account.nil?

    group = Group.find_by :name => params[:group]

    if group and request.connection.ability.can? :read, group
      (group.users + group.services).each do |account|
        account_hash = account.to_ldap
        result = LDAP::Server::Filter.run(filter, account_hash)
        request.send_SearchResultEntry("uid=#{account_hash['uid']},#{baseObject}", account_hash) if result
      end
    end
  end

end
end
end
