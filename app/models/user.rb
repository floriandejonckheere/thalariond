# frozen_string_literal: true

class User < ApplicationRecord
  before_save     :sanitize_attributes
  after_create    :notify_account_created
  before_destroy  :notify_account_deleted

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable,
         :trackable,
         :validatable,
         :lockable,
         :confirmable

  validates :uid,
            :presence => true,
            :uniqueness => true,
            :format => { :with => /[a-z_\-0-9]{3,}/ }

  validate :validate_users_services_unique

  validates :email,
            :presence => true,
            :uniqueness => true
  # Devise takes care of email format validation
  # :format => { with: /\A[^@]+@[^@]+\z/ }

  validates :first_name,
            :presence => true

  # Role-based ACL
  has_and_belongs_to_many :roles,
                          :unique => true,
                          :after_add => %i[notify_role_assigned assign_lower],
                          :after_remove => %i[notify_role_removed unassign_higher]

  has_and_belongs_to_many :groups,
                          :unique => true,
                          :after_add => :notify_access_granted,
                          :after_remove => :notify_access_revoked

  has_many :owned_groups,
           :class_name => 'Group',
           :foreign_key => 'user_id'

  validate :validate_owned_groups_included_in_groups

  has_many :notifications, :dependent => :destroy

  validates_inclusion_of :notifications_enabled, :in => [true, false]

  # Methods
  def has_role?(role_sym)
    roles.any? { |r| r.name.underscore.to_sym == role_sym.downcase }
  end

  def ability
    @ability ||= Ability.new(self)
  end
  delegate :can?, :cannot?, :to => :ability

  def display_name
    if last_name?
      "#{first_name} #{last_name}"
    else
      first_name
    end
  end

  def unread_notifications
    notifications.where.not 'read'
  end

  # Callbacks
  def sanitize_attributes
    uid.downcase!
    email.downcase!
  end

  def notify_role_assigned(role)
    Notification.create! :user => self,
                         :title => 'Role assigned',
                         :text => "Your account has been assigned the <strong>#{role.display_name}</strong> role."
  end

  def notify_role_removed(role)
    Notification.create! :user => self,
                         :title => 'Role removed',
                         :text => "The role <strong>#{role.display_name}</strong> has been removed from your account."
  end

  def notify_access_granted(group)
    text = "You have been granted access to group <strong>#{group.display_name}</strong>."
    if group.email
      text << " This group is associated with the email address <strong>#{group.email}</strong>, which you now also have access to. Please refer to the online documentation for more information."
    end
    Notification.create! :user => self,
                         :title => 'Group access granted',
                         :text => text
  end

  def notify_access_revoked(group)
    Notification.create! :user => self,
                         :title => 'Group access revoked',
                         :text => "Your access to group <strong>#{group.display_name}</strong> has been revoked."
  end

  def notify_account_created
    Notification.create! :user => self,
                         :title => 'Account created',
                         :text => "Your account has been created. Please confirm your email address before you can sign in using the credentials below.<p><strong>Username</strong>: #{uid}<br><strong>Password</strong>: #{password}</p>"
  end

  def notify_account_deleted
    Notification.create! :user => self,
                         :title => 'Account deleted',
                         :text => "The account <strong>#{uid}</strong> has been deleted."
  end

  def notify_account_locked
    Notification.create! :user => self,
                         :title => 'Account locked',
                         :text => "Your account has been locked. You cannot sign in using any connected service. Please contact your <a href='mailto:admin@thalarion.be'>system administrator</a> for more information."
  end

  def notify_account_unlocked
    Notification.create! :user => self,
                         :title => 'Account unlocked',
                         :text => 'Your account has been unlocked.'
  end

  def assign_lower(role)
    return unless role.order?

    role = Role.order(:order).select { |r| r.order? && (r.order < role.order) }.last
    roles << role if role && (!roles.include? role)
  end

  def unassign_higher(role)
    return unless role.order?

    role = Role.order(:order).select { |r| r.order? && (r.order > role.order) }.first

    roles.delete(role) if role && roles.include?(role)
  end

  # Validations
  def validate_users_services_unique
    errors.add(:uid, 'is already taken by a service') if Service.exists?(:uid => uid)
  end

  def validate_owned_groups_included_in_groups
    owned_groups.each do |g|
      errors.add(:owned_groups, 'must be included in groups') unless groups.include? g
    end
  end

  # Overrides
  def active_for_authentication?
    super && enabled && has_role?(:user)
  end

  def confirmation_required?
    enabled? ? super : false
  end

  def inactive_message
    enabled? ? super : :disabled
  end

  def enabled=(value)
    super(value)

    return unless enabled != enabled_was

    enabled ? notify_account_unlocked : notify_account_locked
  end

  def uid=(new_uid)
    raise 'uid is immutable' unless new_record?

    write_attribute :uid, new_uid
  end
end
