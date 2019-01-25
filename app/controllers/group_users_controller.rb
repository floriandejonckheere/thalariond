# frozen_string_literal: true

class GroupUsersController < ApplicationController
  before_action :authenticate_user!

  load_and_authorize_resource :group
  load_and_authorize_resource :user, :through => :group

  def create
    @user = User.find(params[:user][:id])

    @group.users << @user unless @group.users.include? @user

    redirect_to @group
  end

  def destroy
    @group = Group.find(params[:group_id])
    @user = User.find(params[:id])

    @group.users.delete @user
    redirect_to @group
  end
end
