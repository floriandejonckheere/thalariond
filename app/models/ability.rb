class Ability
  include CanCan::Ability

  # Guidelines:
  # :list must always be applied on classes, not on elements

  def initialize(account)
    if account && account.roles
      @account = account
      @account.roles.each { |r| send(r.name.downcase) }
    end
  end

  def base
    can [:list, :read], Service
    can [:list, :read], Role
  end

  def service
    base
    can :read, Group do |group|
      group.services.include? @account
    end
    can :read, User do |user|
      (@account.groups & user.groups).count > 0
    end
  end

  def user
    base
    can [:read, :update], User, :id => @account.id
    can :read, Group do |group|
      group.users.include? @account
    end
    can :read, User do |user|
      (@account.groups & user.groups).count > 0
    end
    can :update, Group, :owner => @account
  end

  def mail
    can [:list, :read], Domain
    can [:list, :read], DomainAlias
    can :read, Email do |email|
      if @account.is_a? User
        (email.permission_group? && email.permission_group.users.include?(@account))
      elsif @account.is_a? Service
        (email.permission_group? && email.permission_group.services.include?(@account))
      end
    end
  end

  def operator
    if @account.is_a? User
      user
    elsif @account.is_a? Service
      service
    end
    can [:list, :read, :update], User
    can [:list, :read, :update], Service
    can [:list, :read, :update], Group

    if @account.has_role? :mail
      can [:list, :read], Domain
      can [:list, :read], DomainAlias
      can [:list, :read, :update], Mail
      can [:list, :read, :update], MailAlias
    end
  end

  def master
    operator
    can [:create, :assign, :destroy], User
    can [:create, :assign, :destroy], Service
    can [:create, :destroy], Group

    if @account.has_role? :mail
      can [:create, :update, :destroy], Domain
      can [:create, :update, :destroy], DomainAlias
      can [:create, :destroy], Mail
      can [:create, :destroy], MailAlias
    end
  end

  def administrator
    can :manage, :all
  end
end
