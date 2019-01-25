# frozen_string_literal: true

class Ability
  include CanCan::Ability

  # Guidelines:
  # :list must always be applied on classes, not on elements
  # :toggle is enabling/disabling accounts
  # :assign is assigning roles to accounts

  # Try to prevent using `User.accessible_by`

  def initialize(account)
    return unless account&.roles

    @account = account
    @account.roles.each { |r| send(r.name.downcase) }
  end

  def base
    can %i[list read], Service
    can %i[list read], Role

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
    can %i[read destroy], Notification, :user_id => @account.id
  end

  def operator
    user if user?
    service if service?

    # Can list, view, update and enable/disable all users
    can %i[list read update toggle], User

    # Can update and enable/disable all services
    can %i[update toggle], Service

    # Can list, view and update all groups
    can %i[list read update], Group
  end

  def master
    operator

    # Can create and delete users
    can %i[create destroy], User

    # Can create and delete services
    can %i[create destroy], Service

    # Can create and delete groups
    can %i[create destroy], Group

    # Can assign all roles except administrator
    can :assign, Role do |role|
      if role.name == 'administrator'
        @account.has_role? :administrator
      else
        true
      end
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
