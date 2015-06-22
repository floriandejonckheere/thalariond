class ServicesController < ApplicationController
  before_filter :authenticate_user!

  layout "panel"

  def index
    authorize! :list, Service
  end
end
