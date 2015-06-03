class Ability
  include CanCan::Ability

  def initialize(user)
    @user ||= User.new
    @user.roles.each { |r| send(r.name.downcase) }

    # Guest access
    if @user.roles.size == 0
    end

    # Service access
    def service

    end

    # User access
    def user

    end

    # Operator access
    def operator
      user

    end

    # Administrator access
    def administrator
      operator

    end
  end
end
