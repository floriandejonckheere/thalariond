class Ability
  include CanCan::Ability

  def initialize(user)
    @user ||= User.new
    @user.roles.each { |r| send(r.name.downcase) }

    # Guest access
    if @user.roles.size == 0
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
    can [:read, :update, :delete], User, :id => user.id
    # RD all memberships participated in
    can [:read, :delete], Membership, :user_id => user.id
    # R all groups participated in
    can :read, Group, :users => { :user_id => user.id }
    # UD all owned groups in
    can [:update, :delete], Group, :owner => { :user_id => user.id }
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
