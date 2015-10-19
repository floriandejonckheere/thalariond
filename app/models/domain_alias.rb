class DomainAlias < ActiveRecord::Base
  has_paper_trail

  validates :alias, presence: true, uniqueness: true
  validates :domain, presence: true
  validate :validate_no_loops

  def validate_no_loops
    errors.add(:alias, "can't be a managed domain") if Domain.find_by(domain: self.alias)
    errors.add(:domain, "can't be an domain alias") unless DomainAlias.find_by(alias: self.domain).nil?
    errors.add(:alias, "can't be aliased to itself") if self.alias == self.domain
  end

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

  def before_save
    self.alias.downcase!
    self.domain.downcase!
  end
end
