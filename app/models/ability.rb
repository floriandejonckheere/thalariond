class Ability
  include CanCan::Ability

  # Available permissions
  # L List
  # C Create
  # R Read
  # A Assign (update permissions)
  # U Update
  # D Delete

  def initialize(user)
    if user && user.roles
      @user = user
      user.roles.each { |r| send(r.name.downcase) }
    end

    alias_action :create, :read, :update, :destroy, :to => :crud
    alias_action :list, :create, :read, :update, :destroy, :to => :lcrud
  end

  # Base permissions
  def base
    # Everyone can list and read services
    can [:list, :read], Service
  end

  def service
    base
    # R own account
    can :read, Service do |s|
      s == @user
    end
    # R all groups participated in
    can :read, Group do |group|
      @user.groups.include? group
    end
  end

  # User access
  def user
    base
    # RUD own account
    can [:read, :update, :delete], User do |u|
      u == @user
    end
    # R all groups participated in
    can :read, Group do |group|
      @user.groups.include? group
    end
    # RU all owned groups in
    can [:read, :update], Group do |group|
      group.owner == @user
    end
  end

  # Operator access
  def operator
    user
    # LCRUD groups
    can :lcrud, Group
    # LCRUD services
    can :lcrud, Service
    # LCRUD emails and aliases
    can :lcrud, Email
    can :lcrud, EmailAlias
  end

  # Master access
  def master
    operator
    # LCRUD domains and aliases
    can :lcrud, Domain
    can :lcrud, DomainAlias
  end

  # Administrator access
  def administrator
    operator
    can :manage, :all
  end

  # Mail service access
  def mail
    service
    # LR domains, emails and aliases
    can [:list, :read], Domain
    can [:list, :read], DomainAlias
    can [:list, :read], Email
    can [:list, :read], EmailAlias
  end
end
