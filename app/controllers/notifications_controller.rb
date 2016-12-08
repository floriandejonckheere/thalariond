class NotificationsController < ApplicationController
  before_action :authenticate_user!

  load_resource
  authorize_resource :except => :index
  skip_authorization_check :only => :index

  layout 'dashboard'

  def index
    @notifications = current_user.notifications.order :timestamp => :desc
    @unread_notifications = @notifications.where :read => false
    @read_notifications = @notifications.where :read => true
  end

  def show
    @notification.update :read => true
  end

  def destroy
    flash[:info] = "Notification deleted"
    @notification.destroy

    redirect_to notifications_path
  end

  def destroy_all
    flash[:info] = "Notifications deleted"
    current_user.notifications.destroy_all
    redirect_to notifications_path
  end

  def update_all
    flash[:info] = "Notifications marked as read"
    current_user.notifications.each { |n| n.read! }
    redirect_to notifications_path
  end

  private
  def group_params
     params.require(:group).permit(:name,
                                    :display_name,
                                    :user_id)
  end
end
