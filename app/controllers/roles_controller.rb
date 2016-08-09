class RolesController < ApplicationController
  before_action :authenticate_user!

  skip_authorization_check

  layout 'dashboard'

  def index
    authorize! :manage, :all
    @roles = Role.all.order :order
  end

  def show
    authorize! :manage, :all
    @role = Role.find params[:id]
  end
end
