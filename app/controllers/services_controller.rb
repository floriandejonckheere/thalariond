class ServicesController < ApplicationController
  before_filter :authenticate_user!

  load_and_authorize_resource
  skip_authorization_check :only => :index

  layout "dashboard"

  # If you're experiencing a ForbiddenAttributesError, check out before_filter in application_controller

  def index
  end

  def create
    if @service.save
      redirect_to @service
    else
      render 'new'
    end
  end

  def new
    password = Service.generate_token
    @service = Service.new(:password => password, :password_confirmation => password)
  end

  def edit
  end

  def show
  end

  def update
    if @service.update(service_params)
      redirect_to @service
    else
      render 'edit'
    end
  end

  def destroy
    flash[:info] = "Service '#{@service.display_name}' deleted"
    @service.destroy

    redirect_to services_path
  end

  private
  def service_params
     params.require(:service).permit(:uid,
                                  :display_name,
                                  :enabled,
                                  :password,
                                  :password_confirmation,
                                  role_ids: [])
  end
end
