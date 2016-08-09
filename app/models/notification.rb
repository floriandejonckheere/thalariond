class Notification < ApplicationRecord
  before_create :generate_timestamp

  belongs_to :user

  validates :priority,
              :presence => true,
              :numericality => { :only_integer => true, :greater_than_or_equal_to => 0 }
  validates :title,
              :presence => true
  validates :text,
              :presence => true
  validates_inclusion_of :read,
                            :in => [true, false]

  after_create :send_notification

  # Methods
  def priority_display
    "Low"
  end

  def read!
    update :read => true
  end

  # Callbacks
  def generate_timestamp
    self.timestamp = DateTime.now
  end

  def send_notification
    return unless Rails.application.config.enable_notifications_mailer
    return unless user.enabled_notifications

    NotificationMailer.delay.notification self
  end
end
