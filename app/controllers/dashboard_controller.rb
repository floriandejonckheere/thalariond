class DashboardController < ApplicationController
  before_filter :authenticate_user!

  layout "panel"

  def index
  end
end