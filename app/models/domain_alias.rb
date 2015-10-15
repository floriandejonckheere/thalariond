class DomainAlias < ActiveRecord::Base
  has_paper_trail

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

  def <=>(domain_alias)
    return self.alias <=> domain_alias.domain if domain_alias.is_a?(Domain)
    self.alias <=> domain_alias.alias
  end
end
