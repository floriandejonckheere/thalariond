class Ability
  include CanCan::Ability

  def initialize(user)
    if user && user.roles
      @user = user
      user.roles.each { |r| send(r.name.downcase) }
    end

    alias_action :create, :read, :update, :destroy, :to => :crud
  end

  # Base permissions
  def base
    # Everyone can read services
    can :read, Service
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
    # RUD all owned groups in
    can [:read, :update, :delete], Group do |group|
      group.owner == @user
    end
  end

  # Service access
  def service
    # R own account
    can :read, Service do |s|
      s == @user
    end
  end

  # Operator access
  def operator
    user
    # CRUD groups
    can :crud, Group
    # CRUD services
    can :crud, Service
  end

  # Administrator access
  def administrator
    operator
    can :manage, :all
  end
end
