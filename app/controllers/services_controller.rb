class ServicesController < ApplicationController
  before_filter :authenticate_user!

  load_and_authorize_resource

  layout "panel"

  # If you're experiencing a ForbiddenAttributesError, check out before_filter in application_controller

  # GET /services
  def index
    authorize! :list, Service
  end

  # POST /services
  def create
    authorize! :create, Service

    password_length = 30
    password = Devise.friendly_token.first(password_length)

    parameters = service_params
    parameters["password"] = password
    parameters["password_confirmation"] = password

    @service = Service.new(parameters)
    if @service.save
      redirect_to @service
    else
      render 'new'
    end
  end

  # GET /services/new
  def new
    authorize! :create, Service
    @service = Service.new
  end

  # GET /services/:id/edit
  def edit
    @service = Service.find(params[:id])
    authorize! :update, @service
  end

  # GET /services/:id
  def show
    @service = Service.find(params[:id])
    authorize! :read, @service
  end

  # PUT/PATCH /services/:id
  def update
    @service = Service.find(params[:id])
    authorize! :update, @service

    if @service.update(service_params)
      redirect_to @service
    else
      render 'edit'
    end
  end

  # DELETE /services/:id
  def destroy
    @service = Service.find(params[:id])
    authorize! :delete, @service

    @service.destroy

    redirect_to services_path
  end

  # Allowed parameters
  protected
  def service_params
     params.require(:service).permit(:uid,
                                  :display_name,
                                  :password,
                                  :password_confirmation)
  end
end
