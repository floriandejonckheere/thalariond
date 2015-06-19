class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      user.roles.each { |r| send(r.name.downcase) }
    end
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
      u == user
    end
    # RUD all owned groups in
    can [:read, :update, :delete], Group do |group|
      group.owner == user
    end
  end

  # Service access
  def service
    # R own account
    can :read, Service do |s|
      s == service
    end
  end

  # Operator access
  def operator
    user
    # CRUD groups
    can :manage, Group
    # CRUD services
    can :manage, Service
  end

  # Administrator access
  def administrator
    operator
    can :manage, :all
  end
end
