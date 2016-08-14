class MyDoorkeeper::AuthorizedApplicationsController < Doorkeeper::ApplicationController
  before_action :authenticate_resource_owner!

  def destroy
    Doorkeeper::AccessToken.revoke_all_for params[:id], current_resource_owner
    redirect_to oauth_applications_path(:anchor => 'authorized'),
                            :notice => I18n.t(:notice, scope: [:doorkeeper, :flash, :authorized_applications, :destroy])
  end
end
