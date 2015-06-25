class Email < ActiveRecord::Base
  validates :mail, presence: true

  belongs_to :domain, -> { uniq }

  validates_uniqueness_of :mail, scope: :domain

  # Methods
  def to_ldap
    h = {}
    h['mail'] = self.mail
    return h
  end
end
