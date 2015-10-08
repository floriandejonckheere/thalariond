class Domain < ActiveRecord::Base
  validates :domain, presence: true, uniqueness: true

  has_many :emails, -> { uniq }, :dependent => :destroy

  # Methods
  def to_ldap
    h = {}
    h['dc'] = self.domain
    h['objectClass'] = 'vmailDomain'
    return h
  end
end
