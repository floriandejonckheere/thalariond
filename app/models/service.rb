class Service < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
          :trackable, :lockable

  # Validations
  validates :uid, presence: true, uniqueness: true
  validates :display_name, presence: true

  # Role-based ACL
  has_and_belongs_to_many :roles, :unique => true

  # Groups
  has_and_belongs_to_many :groups, :unique => true

  # Methods
  def has_role?(role_sym)
    roles.any? { |r| r.name.underscore.to_sym == role_sym.downcase }
  end

  def to_ldap
    h = {}
    h['uid'] = self.uid
    h['objectClass'] = 'serviceAccount'
    h['displayName'] = self.display_name
    h['enabled'] = not self.access_locked?
    return h
  end
end
