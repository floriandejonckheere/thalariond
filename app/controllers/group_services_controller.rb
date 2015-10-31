class GroupServicesController < ApplicationController
  before_filter :authenticate_user!

  load_and_authorize_resource :group
  load_and_authorize_resource :service, :through => :group


  def create
    @service = Service.find(params[:service][:id])

    unless @group.services.include? @service
      @group.services << @service
    end

    redirect_to @group
  end

  def destroy
    @group = Group.find(params[:group_id])
    @service = Service.find(params[:id])

    @group.services.delete @service
    redirect_to @group
  end
end
