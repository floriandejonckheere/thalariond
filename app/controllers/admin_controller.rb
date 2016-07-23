class AdminController < ApplicationController
  before_action :authenticate_user!

  skip_authorization_check

  layout 'dashboard'

  def index
    authorize! :manage, :all
  end
end
