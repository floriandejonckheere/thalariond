class NotificationMailer < ApplicationMailer
  default from: Rails.application.config.devise.mailer_sender
  layout 'mailer'

  def group_access_granted(user, group)
    @group = group
    @notification = Notification.create!(:user => user,
                                          :priority => 0,
                                          :title => 'Group access granted',
                                          :text => "You have been granted access to group #{group.display_name}.")
    mail(:to => user.email, :subject => @notification.title)
  end

  def group_access_revoked(user, group)
    @group = group
    @notification = Notification.create!(:user => user,
                                          :priority => 0,
                                          :title => 'Group access revoked',
                                          :text => "Your access to group #{group.display_name} has been revoked.")
    mail(:to => user.email, :subject => @notification.title)
  end

end
