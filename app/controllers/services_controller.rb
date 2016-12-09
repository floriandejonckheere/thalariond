class ServicesController < ApplicationController
  before_action :authenticate_user!

  load_and_authorize_resource
  skip_authorization_check :only => :index

  layout 'dashboard'

  # If you're experiencing a ForbiddenAttributesError, check out before_action in application_controller

  def index
    @services = Service.all.order :uid
  end

  def create
    if @service.save
      flash[:info] = 'Account created'
      redirect_to @service
    else
      render 'new'
    end
  end

  def new
    password = Service.generate_token
    @service = Service.new :password => password, :password_confirmation => password
  end

  def edit
    @available_roles = []
    Role.all.order(:name).each do |role|
      # Cannot assign already assigned roles
      next if @service.has_role? role.name.to_sym
      # Check assignment authorization
      next unless current_user.can? :assign, role

      @available_roles << role
    end
  end

  def show
  end

  def update
    authorize! :toggle, @service if params[:service][:enabled]

    if @service.update(service_params)
      flash[:info] = 'Account updated'
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

  def reset
    authorize! :update, @service

    flash[:info] = "Secret token reset"
    @service_secret = Service.generate_token
    @service.update!(:password => @service_secret, :password_confirmation => @service_secret)
  end

  private
  def service_params
     params.require(:service).permit(:uid,
                                      :display_name,
                                      :enabled,
                                      :password,
                                      :password_confirmation)
  end
end
