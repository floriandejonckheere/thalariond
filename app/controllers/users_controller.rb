class UsersController < ApplicationController
  before_action :authenticate_user!

  load_and_authorize_resource
  skip_authorization_check :only => :index

  layout 'dashboard'

  # If you're experiencing a ForbiddenAttributesError, check out before_action in application_controller

  def index
    @users = User.order(:uid).select { |u| current_user.can? :read, u }
    @unconfirmed_users = @users.select{ |u| not u.confirmed? }
    @disabled_users = @users.select{ |u| not u.enabled }
    @locked_users = @users.select{ |u| u.access_locked? }
  end

  def create
    password_length = Rails.application.config.devise.password_length.first
    password = Devise.friendly_token.first password_length

    parameters = user_params
    parameters["password"] = password
    parameters["password_confirmation"] = password

    @user = User.new parameters
    if @user.save
      flash[:info] = 'Account created'
      @user.roles << Role.find_by(:name => 'user')
      redirect_to @user
    else
      render 'new'
    end
  end

  def new
  end

  def edit
    @available_roles = []
    Role.all.each do |role|
      # Cannot assign already assigned roles
      next if @user.has_role? role.name.to_sym
      # Check assignment authorization
      next unless current_user.can? :assign, role

      @available_roles << role
    end
  end

  def show
    @events = AuthEvent.where(:user => @user)
                        .where('timestamp > ?', 5.days.ago)
                        .limit(5)
                        .order(:timestamp => :desc)
  end

  def update
    parameters = user_params
    parameters.delete('password') if parameters['password'].blank?
    parameters.delete('password_confirmation') if parameters['password_confirmation'].blank?
    parameters.delete('uid')

    authorize! :toggle, @user if params[:user][:enabled]

    # Prevent disabling of all admin accounts
    if params[:user][:enabled] == "0" and
      @user.has_role? :administrator and
      Role.find_by(:name => 'administrator').users.count == 1
          flash[:danger] = "At least one admin account must be enabled"
          parameters.delete 'enabled'
    end

    if @user.update(parameters)
      flash[:info] = 'Account updated'
      redirect_to @user
    else
      render 'edit'
    end
  end

  def unlock
    @user = User.find(params[:id])
    authorize! :update, @user
    @user.unlock_access!
    redirect_to user_path(@user)
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
