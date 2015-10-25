class UserRolesController < ApplicationController
  before_filter :authenticate_user!

  load_resource :user
  load_resource :role, :through => :user


  def create
    authorize! :assign, @user
    @role = Role.find(params[:role][:id])

    unless @user.roles.include? @role
      @user.roles << @role
    end

    redirect_to @user
  end

  def destroy
    authorize! :assign, @user
    @user = User.find(params[:user_id])
    @role = Role.find(params[:id])

    @user.roles.delete @role
    redirect_to @user
  end
end
