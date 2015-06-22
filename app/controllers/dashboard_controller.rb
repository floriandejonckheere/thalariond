class DashboardController < ApplicationController
  before_filter :authenticate_user!

  layout "panel"

  def index
    authorize! :manage, :all
  end
end
