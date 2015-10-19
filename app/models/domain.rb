class Domain < ActiveRecord::Base
  has_paper_trail

  validates :domain, presence: true, uniqueness: true
  validate :validate_domain_not_alias

  has_many :emails, -> { uniq }, :dependent => :destroy

  def validate_domain_not_alias
    errors.add(:domain, "can't be a domain alias") if DomainAlias.find_by(alias: self.domain)
  end

  def to_ldap
    h = {}
    h['dc'] = self.domain
    h['objectClass'] = 'vmailDomain'
    return h
  end

  def <=>(domain)
    return self.domain <=> domain.alias if domain.is_a?(DomainAlias)
    self.domain <=> domain.domain
  end
end
