class UsersController < ApplicationController
  before_filter :authenticate_user!

  load_and_authorize_resource
  skip_authorization_check :only => :index

  layout "dashboard"

  # If you're experiencing a ForbiddenAttributesError, check out before_filter in application_controller

  def index
    @users = User.accessible_by(current_ability).select { |u| can? :read, u }
  end

  def create
    password_length = Rails.application.config.devise.password_length.first
    password = Devise.friendly_token.first(password_length)

    parameters = user_params
    parameters["password"] = password
    parameters["password_confirmation"] = password

    @user = User.new(parameters)
    if @user.save
      flash[:info] = 'Account created'
      redirect_to @user
    else
      render 'new'
    end
  end

  def new
  end

  def edit
  end

  def show
    @events = AuthEvent.where(:user => @user)
  end

  def update
    parameters = user_params
    parameters.delete('password') if parameters['password'].blank?
    parameters.delete('password_confirmation') if parameters['password_confirmation'].blank?

    # Prevent disabling of all admin accounts
    if (@user.has_role? :administrator and User.select { |u| u.has_role? :administrator and u.enabled?}.count == 1)
      flash[:danger] = "At least one admin account must be enabled"
      parameters.delete('enabled')
    end

    if @user.update(parameters)
      flash[:info] = 'Account updated'
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    # Prevent deletion of all admin accounts
    if (@user.has_role? :administrator and User.select { |u| u.has_role? :administrator}.count == 1)
      flash[:danger] = "At least one admin account must be present"
    else
      flash[:info] = "User '#{@user.display_name}' deleted"
      @user.destroy
    end

    redirect_to users_path
  end

  private
  def user_params
     params.require(:user).permit(:uid,
                                  :first_name,
                                  :last_name,
                                  :email,
                                  :enabled,
                                  :password,
                                  :password_confirmation)
  end
end
