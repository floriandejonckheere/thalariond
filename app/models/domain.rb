class Domain < ActiveRecord::Base
  validates :domain, presence: true, uniqueness: true

  has_many :emails, -> { uniq }, :dependent => :destroy

  # Methods
  def to_ldap
    h = {}
    h['cn'] = self.domain
    return h
  end
end
