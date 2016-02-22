class AdminController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authorize_admin!

  skip_authorization_check

  layout 'dashboard'

  def index
    authorize! :manage, :all
  end
end
