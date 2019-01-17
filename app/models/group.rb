class Group < ApplicationRecord
  has_paper_trail

  before_save :sanitize_attributes
  before_destroy :verify_no_permission_group

  validates :name,
              :presence => true,
              :uniqueness => true
  validates :display_name,
              :presence => true,
              :length => { :maximum => 256 }

  # Membership
  has_and_belongs_to_many :users,
                            :unique => true,
                              :after_add => :notify_access_granted,
                              :after_remove => :notify_access_revoked

  # Ownership
  belongs_to :owner,
                :class_name => 'User',
                :foreign_key => 'user_id',
                :optional => true
  validates_inclusion_of :owner,
                            :in => :users,
                            :allow_blank => true

  # Service membership
  has_and_belongs_to_many :services,
                            :unique => true

  # Permission group
  belongs_to :email,
                    :optional => true

  # Methods
  def email?
    !!self.email
  end

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
    Notification.create! :user => user,
                    :title => 'Group access granted',
                    :text => text
  end

  def notify_access_revoked(user)
    Notification.create! :user => user,
                    :title => 'Group access revoked',
                    :text => "Your access to group <strong>#{self.display_name}</strong> has been revoked."
  end

  # Validations
  # Overrides
end
