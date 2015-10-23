class User < ActiveRecord::Base
  has_paper_trail :skip => [:reset_password_token, :reset_password_sent_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip, :failed_attempts, :unlock_token, :locked_at, :confirmation_token, :confirmed_at, :confirmation_sent_at, :unconfirmed_email]

  include Gravtastic
  gravtastic

  before_save :sanitize_attributes
  after_create :notify_account_created
  before_destroy :notify_account_deleted

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable,
          :trackable, :validatable, :lockable, :confirmable

  validates :uid, presence: true, uniqueness: true, format: { with: /[a-z_\-0-9]{3,}/ }
  validate :validate_users_services_unique
  validates :email, presence: true, uniqueness: true, format: { with: /@/ }
  validate :validate_email_outside_managed_domains
  validates :first_name, presence: true

  # Role-based ACL
  has_and_belongs_to_many :roles, unique: true, :after_add => :notify_role_assigned,
                                                :after_remove => :notify_role_removed

  has_and_belongs_to_many :groups, unique: true, :after_add => :notify_access_granted,
                                                :after_remove => :notify_access_revoked
  has_many :owned_groups, class_name: 'Group', foreign_key: 'user_id'
  validate :validate_owned_groups_included_in_groups

  has_many :notifications

  # Methods
  def has_role?(role_sym)
    roles.any? { |r| r.name.underscore.to_sym == role_sym.downcase }
  end

  def ability
    @ability ||= Ability.new(self)
  end
  delegate :can?, :cannot?, to: :ability

  def display_name
    if self.last_name?
      "#{self.first_name} #{self.last_name}"
    else
      self.first_name
    end
  end

  # Callbacks
  def sanitize_attributes
    self.uid.downcase!
    self.email.downcase!
  end

  def notify_role_assigned(role)
    NotificationMailer.role_assigned(self, role).deliver_later
  end

  def notify_role_removed(role)
    NotificationMailer.role_removed(self, role).deliver_later
  end

  def notify_access_granted(group)
    NotificationMailer.group_access_granted(self, group).deliver_later
  end

  def notify_access_revoked(group)
    NotificationMailer.group_access_revoked(self, group).deliver_later
  end

  def notify_account_created
    NotificationMailer.account_created(self).deliver_later
  end

  def notify_account_deleted
    NotificationMailer.account_deleted(self).deliver_later
  end

  # Validations
  def validate_users_services_unique
    errors.add(:uid, "is already taken by a service") if Service.find_by(uid: self.uid).present?
  end

  def validate_email_outside_managed_domains
    errors.add(:email, "can't be inside a registered domain") if Domain.find_by(domain: email.split('@')[1]).present?
  end

  def validate_owned_groups_included_in_groups
    owned_groups.each do |g|
      errors.add(:owned_groups, 'must be included in groups') if !groups.include? g
    end
  end

  # Overrides
  def to_ldap
    h = {}
    h['uid'] = self.uid
    h['objectClass'] = 'userAccount'
    h['givenName'] = self.first_name
    h['sn'] = self.last_name if self.last_name?
    h['mail'] = self.email
    h['enabled'] = self.active_for_authentication?
    return h
  end

  def active_for_authentication?
    super && self.enabled
  end
end
