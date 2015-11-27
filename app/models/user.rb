class User < ActiveRecord::Base
  has_paper_trail :skip => [:reset_password_token, :reset_password_sent_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip, :failed_attempts, :unlock_token, :locked_at, :confirmation_token, :confirmed_at, :confirmation_sent_at, :unconfirmed_email]

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
  has_and_belongs_to_many :roles, unique: true, :after_add => [:notify_role_assigned, :assign_lower],
                                                :after_remove => [:notify_role_removed, :unassign_higher]
  has_and_belongs_to_many :groups, unique: true, :after_add => :notify_access_granted,
                                                :after_remove => :notify_access_revoked
  has_many :owned_groups, class_name: 'Group', foreign_key: 'user_id'
  validate :validate_owned_groups_included_in_groups

  has_many :notifications, :dependent => :destroy

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
    NotificationMailer.delay.notification(Notification.create!(:user => self,
            :title => 'Role assigned',
            :text => "Your account has been assigned the <strong>#{role.display_name}</strong> role.")
    )
  end

  def notify_role_removed(role)
    NotificationMailer.delay.notification(Notification.create!(:user => self,
            :title => 'Role removed',
            :text => "The role <strong>#{role.display_name}</strong> has been removed from your account.")
    )
  end

  def notify_access_granted(group)
    text = "You have been granted access to group <strong>#{group.display_name}</strong>."
    if group.email
      text << " This group is associated with the email address <strong>#{group.email}</strong>, which you now also have access to. Please refer to the online documentation for more information."
    end
    NotificationMailer.delay.notification(Notification.create!(:user => self,
            :title => 'Group access granted',
            :text => text)
    )
  end

  def notify_access_revoked(group)
    NotificationMailer.delay.notification(Notification.create!(:user => self,
            :title => 'Group access revoked',
            :text => "Your access to group <strong>#{group.display_name}</strong> has been revoked.")
    )
  end

  def notify_account_created
    NotificationMailer.delay.notification(Notification.create!(:user => self,
            :title => 'Account created',
            :text => "Your account has been created. Please confirm your email address before you can sign in using the credentials below.<p><strong>Username</strong>: #{self.uid}<br><strong>Password</strong>: #{self.password}</p>")
    )
  end

  def notify_account_deleted
    NotificationMailer.delay.notification(Notification.create!(:user => self,
            :title => 'Account deleted',
            :text => "The account <strong>#{self.uid}</strong> has been deleted.")
    )
  end

  def notify_account_locked
    NotificationMailer.delay.notification(Notification.create!(:user => self,
            :title => 'Account locked',
            :text => "Your account has been locked. You cannot sign in using any connected service. Please contact your <a href='mailto:admin@thalarion.be'>system administrator</a> for more information.")
    )
  end

  def notify_account_unlocked
    NotificationMailer.delay.notification(Notification.create!(:user => self,
            :title => 'Account unlocked',
            :text => "Your account has been unlocked.")
    )
  end


  def assign_lower(role)
    if role.order?
      role = Role.order(:order).select { |r| r.order? and r.order < role.order }.last
      self.roles << role if role and not self.roles.include? role
    end
  end

  def unassign_higher(role)
    if role.order?
      role = Role.order(:order).select { |r| r.order? and r.order > role.order }.first
      self.roles.delete(role) if role and self.roles.include? role
    end
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
    h['enabled'] = self.active_for_authentication?.to_s
    # TODO: roles
    if self.groups.any?
      h['group'] = []
      self.groups.each do |g|
        h['group'] << "cn=#{g.name},ou=Groups,#{Rails.application.config.ldap['base_dn']}"
      end
    end
    if self.roles.any?
      h['role'] = []
      self.roles.each do |r|
        h['role'] << r.name
      end
    end
    return h
  end

  def active_for_authentication?
    super && self.enabled
  end

  def inactive_message
    self.enabled? ? super : :disabled
  end


  def enabled=(value)
    super(value)

    if self.enabled != self.enabled_was
      if self.enabled
        notify_account_unlocked
      else
        notify_account_locked
      end
    end
  end

  def uid=(new_uid)
    if new_record?
      write_attribute(:uid, new_uid)
    else
      raise 'uid is immutable'
    end
  end
end
