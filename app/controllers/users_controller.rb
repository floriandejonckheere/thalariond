class UsersController < ApplicationController
  before_filter :authenticate_user!

  load_resource

  layout "dashboard"

  # If you're experiencing a ForbiddenAttributesError, check out before_filter in application_controller

  def index
  end

  def create
    authorize! :create, User

    password_length = Rails.application.config.devise.password_length.first
    password = Devise.friendly_token.first(password_length)

    parameters = user_params
    parameters["password"] = password
    parameters["password_confirmation"] = password

    @user = User.new(parameters)
    if @user.save
      redirect_to @user
    else
      render 'new'
    end
  end

  def new
    authorize! :create, User
  end

  def edit
    authorize! :update, @user
  end

  def show
    authorize! :read, @user

    @events = AuthEvent.where(:user => @user)
  end

  def update
    authorize! :update, @user

    parameters = user_params
    parameters.delete('password') if parameters['password'].blank?
    parameters.delete('password_confirmation') if parameters['password_confirmation'].blank?

    if @user.update(parameters)
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    authorize! :destroy, @user

    # Prevent deletion of all admin accounts
    if (@user.has_role? :administrator and User.select { |u| u.has_role? :administrator}.count == 1)
      flash[:danger] = "At least one admin account must be present"
    else
      flash[:info] = "Account '#{@user.display_name}' deleted"
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
                                  :password,
                                  :password_confirmation,
                                  role_ids: [])
  end
end
