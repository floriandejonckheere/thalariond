require 'cancan'

module LDAPd
class LDAPController

  def self.bindUser(request, version, dn, password, params)
    dn.downcase!

    raise LDAP::ResultError::InvalidCredentials if params[:uid].nil?
    raise LDAP::ResultError::InvalidCredentials if password.nil?
    user = User.find_by(:uid => params[:uid])
    raise LDAP::ResultError::InvalidCredentials if user.nil?
    raise LDAP::ResultError::InvalidCredentials if not user.valid_password? password
  end

  def self.bindService(request, version, dn, password, params)
    dn.downcase!

    raise LDAP::ResultError::InvalidCredentials if params[:uid].nil?
    raise LDAP::ResultError::InvalidCredentials if password.nil?
    service = Service.find_by(:uid => params[:uid])
    raise LDAP::ResultError::InvalidCredentials if service.nil?
    raise LDAP::ResultError::InvalidCredentials if not service.valid_password? password
  end

  def self.bindMail(request, version, dn, password, params)
    dn.downcase!

    raise LDAP::ResultError::InvalidCredentials if params[:mail].nil?
    raise LDAP::ResultError::InvalidCredentials if params[:dc].nil?
    raise LDAP::ResultError::InvalidCredentials if password.nil?
    domain = Domain.find_by(:domain => params[:domain])
    raise LDAP::ResultError::InvalidCredentials if domain.nil?
    email = domain.emails.find_by(:mail => params[:mail])
    raise LDAP::ResultError::InvalidCredentials if email.nil?
    group = email.permission_group
    raise LDAP::ResultError::InvalidCredentials if group.nil?

    group.users.each do |user|
      return true if user.valid_password? password
    end
    group.services.each do |service|
      return true if service.valid_password? password
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
      return true if user.valid_password? password
    end
    group.services.each do |service|
      return true if service.valid_password? password
    end
    raise LDAP::ResultError::InvalidCredentials
  end

end
end
