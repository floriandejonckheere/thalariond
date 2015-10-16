class Ability
  include CanCan::Ability

  # Available permissions
  # L List
  # C Create
  # R Read
  # A Assign (update permissions)
  # U Update
  # D Destroy

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
    # Everyone can read domains
    can :read, Domain
    # Everyone can list and read roles
    can [:list, :read], Role
  end

  # Service permissions
  def service
    base
    # R own account
    can :read, Service do |s|
      s == @user
    end
    # R all groups participated in
    can :read, Group do |group|
      group.users.include? @user
    end
  end

  # User access
  def user
    base
    # RUD own account
    can [:read, :update, :destroy], User do |u|
      u.id == @user.id
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
    # LR domains and aliases
    can [:list, :read], Domain
    can [:list, :read], DomainAlias
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
