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
    # RD all memberships participated in
    can [:read, :delete], Membership do |membership|
      membership.user == user
    end
    # R all groups participated in
    can :read, Group do |group|
      group.users.any? { |u| u.id == user.id }
    end
    # UD all owned groups in
    can [:update, :delete], Group do |group|
      group.owner == user
    end
  end

  # Service access
  def service
    # R own account
    can :read, Service, :id => service.id
    # R all memberships participated in
    can :read, ServiceMembership, :service_id => service.id
    # R all groups participated in
    can :read, Group, :services => { :service_id => service.id }
  end

  # Operator access
  def operator
    user
    # CRUD memberships
    can :manage, Membership
    can :manage, ServiceMembership
    # CRUD groups
    can :manage, Group
  end

  # Administrator access
  def administrator
    operator
    can :manage, :all
  end
end
