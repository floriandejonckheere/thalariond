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

  def role_assigned(user, role)
    @role = role
    @notification = Notification.create!(:user => user,
                                          :priority => 0,
                                          :title => 'Role assigned',
                                          :text => "Your account has been granted the role #{role.display_name}.")
    mail(:to => user.email, :subject => @notification.title)
  end

  def role_removed(user, role)
    @role = role
    @notification = Notification.create!(:user => user,
                                          :priority => 0,
                                          :title => 'Role removed',
                                          :text => "The role #{role.display_name} has been removed from your account.")
    mail(:to => user.email, :subject => @notification.title)
  end

  def account_created(user)
    @user = user
    @notification = Notification.create!(:user => user,
                                          :priority => 0,
                                          :title => 'Account created',
                                          :text => "The account '#{user.uid}' for #{user.display_name} has been created.")
    mail(:to => user.email, :subject => @notification.title)
  end

  def account_deleted(user)
    @user = user
    @notification = Notification.create!(:user => user,
                                          :priority => 0,
                                          :title => 'Account deleted',
                                          :text => "The account '#{user.uid}' has been deleted.")
    mail(:to => user.email, :subject => @notification.title)
  end

end
