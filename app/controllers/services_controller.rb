class ServicesController < ApplicationController
  before_filter :authenticate_user!

  load_resource

  layout "dashboard"

  # If you're experiencing a ForbiddenAttributesError, check out before_filter in application_controller

  def index
  end

  def create
    authorize! :create, Service

    @service = Service.new(service_params)
    if @service.save
      redirect_to @service
    else
      render 'new'
    end
  end

  def new
    authorize! :create, Service

    password = Service.generate_token
    @service = Service.new(:password => password, :password_confirmation => password)
  end

  def edit
    authorize! :update, @service
  end

  def show
    authorize! :read, @service
  end

  def update
    authorize! :update, @service

    if @service.update(service_params)
      redirect_to @service
    else
      render 'edit'
    end
  end

  def destroy
    authorize! :destroy, @service

    flash[:info] = "Service deleted"
    @service.destroy

    redirect_to services_path
  end

  private
  def service_params
     params.require(:service).permit(:uid,
                                  :display_name,
                                  :password,
                                  :password_confirmation,
                                  role_ids: [])
  end
end
