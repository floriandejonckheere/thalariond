class MailController < ApplicationController
  before_filter :authenticate_user!

  load_and_authorize_resource

  layout "dashboard"

  def index
  end

end
