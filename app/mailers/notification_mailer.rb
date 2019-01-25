# frozen_string_literal: true

class NotificationMailer < ApplicationMailer
  default :from => Rails.application.config.devise.mailer_sender
  layout 'mailer'

  def notification(notification)
    @notification = notification

    mail(:to => notification.user.email,
         :subject => notification.title)
  end
end
