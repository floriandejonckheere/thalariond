class DomainAlias < ActiveRecord::Base
  validates :alias, presence: true, uniqueness: true
  validates :domain, presence: true

  # Methods
  def to_ldap
    h = {}
    h['alias'] = self.alias
    h['dc'] = self.domain
    h['objectClass'] = 'vmailDomainAlias'
    return h
  end
end
