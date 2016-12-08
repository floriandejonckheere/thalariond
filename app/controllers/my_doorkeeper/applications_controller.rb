class MyDoorkeeper::ApplicationsController < Doorkeeper::ApplicationsController
  def index
    @applications = Doorkeeper::Application.all.order :name
    @authorized_applications = Doorkeeper::Application.authorized_for(current_resource_owner).order :name
  end
end
