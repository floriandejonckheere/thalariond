class Ability
  include CanCan::Ability

  # Guidelines:
  # :list must always be applied on classes, not on elements
  # :toggle is enabling/disabling accounts
  # :assign is assigning roles to accounts

  def initialize(account)
    if account && account.roles
      @account = account
      @account.roles.each { |r| send(r.name.downcase) }
    end
  end

  def base
    can [:list, :read], Service
    can [:list, :read], Role

    # WARNING: User.accessible_by gives you ALL the Users, authorize each one separately
    can :read, User, [] do |user|
      (@account.groups & user.groups).count > 0
    end
  end

  def service
    base
    can :read, Group, :services => { :id => @account.id }
  end

  def user
    base
    can [:read, :update], User, :id => @account.id
    can :read, Group, :users => { :id => @account.id }
    can :update, Group, :owner => @account
    can [:read, :destroy], Notification, :user_id => @account.id
  end

  def mail
    can [:list, :read], Domain
    can [:list, :read], DomainAlias
    if user?
      can :read, Email, :group => { :users => { :id => @account.id } }
    elsif service?
      can :read, Email, :group => { :services => { :id => @account.id } }
    end
    can [:list, :read], EmailAlias
  end

  def operator
    if user?
      user
    elsif service?
      service
    end
    can [:list, :read, :update, :toggle], User
    can [:update, :toggle], Service
    can [:list, :read, :update], Group

    if @account.has_role? :mail
      can [:list, :read, :update], Email
      can [:list, :read, :update], EmailAlias
    end
  end

  def master
    operator
    can [:create, :destroy], User
    can [:create, :destroy], Service
    can [:create, :destroy], Group

    can :assign, Role do |role|
      if role.name == 'administrator'
        @account.has_role? :administrator
      else
        true
      end
    end

    if @account.has_role? :mail
      can [:create, :update, :destroy], Domain
      can [:create, :update, :destroy], DomainAlias
      can [:create, :destroy], Email
      can [:create, :destroy], EmailAlias
    end
  end

  def administrator
    can :manage, :all
  end

  # Helpers
  def user?
    @account.is_a? User
  end

  def service?
    @account.is_a? Service
  end
end
