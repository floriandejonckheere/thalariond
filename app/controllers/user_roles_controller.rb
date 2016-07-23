class UserRolesController < ApplicationController
  before_action :authenticate_user!

  load_resource :user
  load_resource :role, :through => :user


  def create
    authorize! :assign, Role
    @role = Role.find(params[:role][:id])

    if current_user.can? :assign, @role
      @user.roles << @role
    else
      @user.errors << "You do not have enough permissions to assign this role"
    end

    redirect_to edit_user_path(@user)
  end

  def destroy
    authorize! :assign, Role
    @user = User.find(params[:user_id])
    @role = Role.find(params[:id])

    if current_user.can? :assign, @role
      @user.roles.delete @role
    else
      @user.errors << "You do not have enough permissions to assign this role"
    end

    redirect_to edit_user_path(@user)
  end
end
