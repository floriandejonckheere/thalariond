class UsersController < ApplicationController
  before_filter :authenticate_user!

  load_and_authorize_resource

  layout "panel"

  # GET /users
  def index
    authorize! :read, User
  end

  # POST /users
  def create
    authorize! :create, User

    password_length = 8
    password = Devise.friendly_token.first(password_length)

    @user = User.new(user_params, :password => password)
    if @user.save
      redirect_to @user
    else
      render 'new'
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/:id/edit
  def edit
    @user = User.find(params[:id])
  end

  # GET /users/:id
  def show
    @user = User.find(params[:id])
  end

  # PUT/PATCH /users/:id
  def update
    @user = User.find(params[:id])

    authorize! :update, @user

    if @user.update(user_params)
      redirect_to @user
    else
      render 'edit'
    end
  end

  # DELETE /users/:id
  def destroy
    @user = User.find(params[:id])
    authorize! :delete, @user

    @user.destroy

    redirect_to users_path
  end

  # Allowed parameters
  private
  def user_params
     params.require(:user).permit(:uid, :first_name, :last_name, :email)
  end

end
