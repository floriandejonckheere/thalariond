class DomainAlias < ApplicationRecord
  # Domain aliases have two attributes: alias and domain.
  # alias ALWAYS means the pointing domain
  # domain ALWAYS means the pointed to domain

  has_paper_trail

  before_save :sanitize_attributes

  validates :alias, presence: true, uniqueness: true, length: { in: 3..253 }
  validates :domain, presence: true, length: { in: 3..253 }
  validate :validate_domain_syntax
  validate :validate_no_loops
  validate :validate_alias_not_domain


  # Methods
  # Callbacks
  def sanitize_attributes
    self.alias.downcase!
    self.domain.downcase!
  end


  # Validations
  def validate_domain_syntax
    errors.add(:alias, "can't have more than 127 levels") if self.alias.split('.').length > 126
    errors.add(:domain, "can't have more than 127 levels") if self.domain.split('.').length > 126
    self.alias.split('.').each do |sub|
      errors.add(:alias_domain_component, "must be between 1 and 63 characters") if not sub.length.between?(1, 63)
    end
    self.domain.split('.').each do |sub|
      errors.add(:domain_component, "must be between 1 and 63 characters") if not sub.length.between?(1, 63)
    end
  end

  def validate_alias_not_domain
    errors.add(:alias, "can't be a managed domain") if Domain.find_by(domain: self.alias)
  end

  def validate_no_loops
    errors.add(:domain, "can't be an domain alias") unless DomainAlias.find_by(alias: self.domain).nil?
    errors.add(:alias, "can't be aliased to itself") if self.alias == self.domain
  end


  # Overrides
  def to_ldap
    h = {}
    h['alias'] = self.alias
    h['dc'] = self.domain
    h['objectClass'] = 'domainAlias'
    return h
  end

  def <=>(domain_alias)
    return self.alias <=> domain_alias.domain if domain_alias.is_a?(Domain)
    self.alias <=> domain_alias.alias
  end
end
