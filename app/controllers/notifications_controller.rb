class NotificationsController < ApplicationController
  before_filter :authenticate_user!

  load_and_authorize_resource

  layout "dashboard"

  def index
    @notifications = current_user.notifications
  end

  def show
    @notification.update(:read => true)
  end

  def destroy
    flash[:info] = "Notification deleted"
    @notification.destroy

    redirect_to notifications_path
  end

  private
  def group_params
     params.require(:group).permit(:name, :display_name, :user_id)
  end

end