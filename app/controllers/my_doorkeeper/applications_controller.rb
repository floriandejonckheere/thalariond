class MyDoorkeeper::ApplicationsController < Doorkeeper::ApplicationsController
  def index
    @applications = Doorkeeper::Application.all
    @authorized_applications = Doorkeeper::Application.authorized_for(current_resource_owner)
  end
end
