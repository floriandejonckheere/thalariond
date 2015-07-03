class Email < ActiveRecord::Base
  validates :mail, presence: true

  belongs_to :domain, -> { uniq }

  validates_uniqueness_of :mail, scope: :domain

  before_create :create_permission_group

  # Methods
  def create_permission_group
    email = self.mail + '@' + self.domain.domain
    group = Group.create!(:name => email,
                          :display_name => 'Email account for ' + email)
  end

  def to_ldap
    h = {}
    h['mail'] = self.mail
    return h
  end
end
