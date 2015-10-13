class User < ActiveRecord::Base
  include Gravtastic
  gravtastic

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable,
          :trackable, :validatable, :lockable, :confirmable

  # Validations
  validates :uid, presence: true, uniqueness: true, format: { with: /[a-z_\-0-9]{3,}/ }
  validates :email, presence: true, uniqueness: true, format: { with: /@/ }
  validate :email_outside_managed_domains
  validates :first_name, presence: true

  # Role-based ACL
  has_and_belongs_to_many :roles, unique: true

  # Groups
  has_and_belongs_to_many :groups, unique: true
  has_many :owned_groups, class_name: 'Group', foreign_key: 'user_id'
  #~ validates_associated :owned_groups
  validate :owned_groups_included_in_groups

  ## Methods
  def has_role?(role_sym)
    roles.any? { |r| r.name.underscore.to_sym == role_sym.downcase }
  end

  def ability
    @ability ||= Ability.new(self)
  end
  delegate :can?, :cannot?, to: :ability

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

  def display_name
    name = self.first_name
    name << ' ' + self.last_name if self.last_name?
    return name
  end

  def display_roles
    self.roles.map(&:display_name).join ', '
  end

  # Overrides Devise's active_for_authentication?
  def active_for_authentication?
    super && self.enabled
  end

  ## Validations
  def email_outside_managed_domains
    if Domain.find_by(domain: email.split('@')[1]).present?
      errors.add(:email, "can't be inside a registered domain")
    end
  end

  def owned_groups_included_in_groups
    owned_groups.each do |g|
      if !groups.include? g
        errors.add(:owned_groups, 'must be included in groups')
      end
    end
  end
end
