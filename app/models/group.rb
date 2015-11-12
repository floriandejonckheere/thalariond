class Group < ActiveRecord::Base
  has_paper_trail

  before_save :sanitize_attributes
  before_destroy :verify_no_permission_group

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

  # Permission group
  belongs_to :email

  # Methods
  # Callbacks
  def sanitize_attributes
    self.name.downcase!
  end

  def verify_no_permission_group
    if self.email
      errors[:base] = 'Cannot delete a permission group'
      false
    end
  end

  def notify_access_granted(user)
    text = "You have been granted access to group <strong>#{self.display_name}</strong>."
    if self.email
      text << " This group is associated with the email address <strong>#{self.email}</strong>, which you now also have access to. Please refer to the online documentation for more information."
    end
    NotificationMailer.delay.notification(Notification.create!(:user => user,
            :title => 'Group access granted',
            :text => text)
    )
  end

  def notify_access_revoked(user)
    NotificationMailer.delay.notification(Notification.create!(:user => user,
            :title => 'Group access revoked',
            :text => "Your access to group <strong>#{self.display_name}</strong> has been revoked.")
    )
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
      self.services.each do |u|
        h['member'] << "uid=#{u.uid},ou=Services,#{Rails.application.config.ldap['base_dn']}"
      end
    end
    return h
  end
end
