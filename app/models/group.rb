class Group < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true

  # Membership
  has_and_belongs_to_many :users, unique: true

  # Ownership
  belongs_to :owner, class_name: 'User', foreign_key: 'user_id'
  validates_inclusion_of :owner, in: :users, allow_blank: true

  # Service membership
  has_and_belongs_to_many :services, unique: true

  # Methods
  def to_ldap
    h = {}
    h['cn'] = self.name
    h['displayName'] = self.display_name if self.display_name?
    h['owner'] = "uid=#{self.owner.uid},ou=Users,#{Rails.application.config.ldap['base_dn']}" if self.owner != nil
    # Members
    if self.users.length > 0
      h['member'] = []
      self.users.each do |u|
        h['member'] << "uid=#{u.uid},ou=Users,#{Rails.application.config.ldap['base_dn']}"
      end
    end
    if self.services.length > 0
      h['member'] = []
      self.services.each do |s|
        h['member'] << "uid=#{s.uid},ou=Services,#{Rails.application.config.ldap['base_dn']}"
      end
    end
    return h
  end
end
