class Group < ActiveRecord::Base
  has_paper_trail

  before_save :sanitize_attributes

  validates :name, presence: true, uniqueness: true
  validates :display_name, presence: true, length: { maximum: 256 }

  # Membership
  has_and_belongs_to_many :users, unique: true, :after_add => :notify_access_granted,
                                                :after_remove => :notify_access_revoked

  # Ownership
  belongs_to :owner, class_name: 'User', foreign_key: 'user_id'
  validates_inclusion_of :owner, in: :users, allow_blank: true

  # Service membership
  has_and_belongs_to_many :services, unique: true

  # Methods
  # Callbacks
  def sanitize_attributes
    self.name.downcase!
  end

  # Validations
  # Overrides
  def to_ldap
    h = {}
    h['cn'] = self.name
    h['objectClass'] = 'group'
    h['displayName'] = self.display_name if self.display_name?
    h['owner'] = "uid=#{self.owner.uid},ou=Users,#{Rails.application.config.ldap['base_dn']}" if self.owner != nil
    # Members
    if self.users.any?
      h['member'] = []
      self.users.each do |u|
        h['member'] << "uid=#{u.uid},ou=Users,#{Rails.application.config.ldap['base_dn']}"
      end
    end
    if self.services.any?
      h['member'] = []
      self.services.each do |s|
        h['member'] << "uid=#{s.uid},ou=Services,#{Rails.application.config.ldap['base_dn']}"
      end
    end
    return h
  end
end
