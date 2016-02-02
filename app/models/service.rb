class Service < ActiveRecord::Base
  has_paper_trail :skip => [:sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip, :failed_attempts, :unlock_token, :locked_at]

  before_save :sanitize_attributes

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :trackable

  # Validations
  validates :uid, presence: true, uniqueness: true
  validate :validate_users_services_unique
  validates :display_name, presence: true

  # Role-based ACL
  has_and_belongs_to_many :roles, :unique => true

  # Groups
  has_and_belongs_to_many :groups, :unique => true


  # Methods
  def has_role?(role_sym)
    roles.any? { |r| r.name.underscore.to_sym == role_sym.downcase }
  end

  def ability
    @ability ||= Ability.new(self)
  end
  delegate :can?, :cannot?, to: :ability

  def self.generate_token(length = 75)
    SecureRandom.base64(length).tr('lIO0', 'sxyz').delete('/=+')[0..length - 1]
  end

  # Callbacks
  def sanitize_attributes
    self.uid.downcase!
  end

  # Validations
  def validate_users_services_unique
    errors.add(:uid, "is already taken by a user") if User.exists?(:uid => self.uid)
  end

  # Overrides
  def to_ldap
    h = {}
    h['uid'] = self.uid
    h['objectClass'] = 'serviceAccount'
    h['displayName'] = self.display_name
    h['enabled'] = self.active_for_authentication?.to_s
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

  # Overrides Devise's active_for_authentication?
  def active_for_authentication?
    super && self.enabled
  end
end
