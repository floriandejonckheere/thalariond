class ServiceRolesController < ApplicationController
  before_filter :authenticate_user!

  load_resource :service
  load_resource :role, :through => :service

  def create
    authorize! :assign, @user
    @role = Role.find(params[:role][:id])

    unless @service.roles.include? @role
      @service.roles << @role
    end

    redirect_to edit_service_path(@service)
  end

  def destroy
    authorize! :assign, @user
    @service = Service.find(params[:service_id])
    @role = Role.find(params[:id])

    @service.roles.delete @role
    redirect_to edit_service_path(@service)
  end
end
