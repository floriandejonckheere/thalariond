class DashboardController < ApplicationController
  before_filter :authenticate_user!

  layout "dashboard"

  def index
    authorize! :manage, :all
  end
end
