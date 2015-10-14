class UsersController < ApplicationController
  before_filter :authenticate_user!

  load_and_authorize_resource

  layout "dashboard"

  # If you're experiencing a ForbiddenAttributesError, check out before_filter in application_controller

  # GET /users
  def index
    authorize! :list, User
  end

  # POST /users
  def create
    authorize! :create, User

    password_length = 8
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

  # GET /users/new
  def new
    authorize! :create, User
    @user = User.new
  end

  # GET /users/:id/edit
  def edit
    @user = User.find(params[:id])
    authorize! :update, @user
  end

  # GET /users/:id
  def show
    @user = User.find(params[:id])
    authorize! :read, @user
  end

  # PUT/PATCH /users/:id
  def update
    @user = User.find(params[:id])
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

  # DELETE /users/:id
  def destroy
    @user = User.find(params[:id])
    authorize! :destroy, @user

    # Prevent deletion of admin account
    if @user.uid == 'admin'
      flash[:user] = "Admin account cannot be deleted"
    else
      @user.destroy
    end

    redirect_to users_path
  end

  # Allowed parameters
  protected
  def user_params
     params.require(:user).permit(:uid,
                                  :first_name,
                                  :last_name,
                                  :email,
                                  :password,
                                  :password_confirmation,
                                  :roles,
                                  role_ids: [])
  end
end
