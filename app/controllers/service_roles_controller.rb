class ServiceRolesController < ApplicationController
  before_action :authenticate_user!

  load_resource :service
  load_resource :role, :through => :service

  def create
    authorize! :assign, @service
    @role = Role.find(params[:role][:id])

    if current_user.can? :assign, @role
      @service.roles << @role
    else
      @user.errors << "You do not have enough permissions to assign this role"
    end

    redirect_to edit_service_path(@service)
  end

  def destroy
    authorize! :assign, @service
    @service = Service.find(params[:service_id])
    @role = Role.find(params[:id])

    if current_user.can? :assign, @role
      @service.roles.delete @role
    else
      @user.errors << "You do not have enough permissions to assign this role"
    end

    redirect_to edit_service_path(@service)
  end
end
