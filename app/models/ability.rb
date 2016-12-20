class Ability
  include CanCan::Ability

  # Guidelines:
  # :list must always be applied on classes, not on elements
  # :toggle is enabling/disabling accounts
  # :assign is assigning roles to accounts

  # Try to prevent using `User.accessible_by`


  def initialize(account)
    if account&.roles
      @account = account
      @account.roles.each { |r| send(r.name.downcase) }
    end
  end

  def base
    can [:list, :read], Service
    can [:list, :read], Role

    # WARNING: User.accessible_by gives you ALL the Users, authorize each one separately
    # can :read, User, [] do |user|
    #   (@account.groups & user.groups).any?
    # end
    # can :read, User, :groups => { :users => { :id => @account.id } }
  end

  def service
    base

    # Can read subscribed groups
    can :read, Group, :services => { :id => @account.id }

    # Can read users which have subscribed groups in common
    can :read, User, :groups => { :services => { :id => @account.id } }
  end

  def user
    base

    # Can read subscribed groups
    can :read, Group, :users => { :id => @account.id }

    # Can update owned groups
    can :update, Group, :owner => @account

    # Can read users which have subscribed groups in common
    can :read, User, :groups => { :users => { :id => @account.id } }

    # Can update self
    can :update, User, :id => @account.id

    # Can read and delete own notifications
    can [:read, :destroy], Notification, :user_id => @account.id
  end

  def mail
    # Can list and view domains and aliases
    can [:list, :read], Domain
    can [:list, :read], DomainAlias

    # User can read email of subscribed groups
    can :read, Email, :group => { :users => { :id => @account.id } } if user?

    # Service can read email of subscribed groups
    can :read, Email, :group => { :services => { :id => @account.id } } if service?

    # Can list and view email aliases
    can [:list, :read], EmailAlias
  end

  def operator
    user if user?
    service if service?

    # Can list, view, update and enable/disable all users
    can [:list, :read, :update, :toggle], User

    # Can update and enable/disable all services
    can [:update, :toggle], Service

    # Can list, view and update all groups
    can [:list, :read, :update], Group

    if @account.has_role? :mail
      can [:list, :read, :update], Email
      can [:list, :read, :update], EmailAlias
    end
  end

  def master
    operator

    # Can create and delete users
    can [:create, :destroy], User

    # Can create and delete services
    can [:create, :destroy], Service

    # Can create and delete groups
    can [:create, :destroy], Group

    # Can assign all roles except administrator
    can :assign, Role do |role|
      if role.name == 'administrator'
        @account.has_role? :administrator
      else
        true
      end
    end

    if mail?
      # Can manage all email aspects
      can :manage, Domain
      can :manage, DomainAlias
      can :manage, Email
      can :manage, EmailAlias
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

  def mail?
    @account.has_role? :mail
  end
end
