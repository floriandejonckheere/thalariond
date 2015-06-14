class UsersController < ApplicationController
  before_filter :authenticate_user!

  load_and_authorize_resource

  layout "panel"

  def index
  end

  def show
    p "WUT LOL #{params[:id]}"
    @user = User.find(params[:id])
  end

end
