class Domain < ActiveRecord::Base
  has_paper_trail

  before_save :sanitize_attributes

  validates :domain, presence: true, uniqueness: true, length: { in: 1..253 }
  validate :validate_domain_syntax
  validate :validate_domain_not_alias

  has_many :emails, -> { uniq }, :dependent => :destroy


  # Methods
  # Callbacks
  def sanitize_attributes
    self.domain.downcase!
  end


  # Validations
  def validate_domain_syntax
    errors.add(:domain, "can't have more than 127 levels") if self.domain.split('.').length > 126
    self.domain.split('.').each do |sub|
      errors.add(:domain_component, "must be between 1 and 63 characters") if not sub.length.between?(1, 63)
    end
  end

  def validate_domain_not_alias
    errors.add(:domain, "can't be a domain alias") if DomainAlias.find_by(alias: self.domain)
  end


  # Overrides
  def to_ldap
    h = {}
    h['dc'] = self.domain
    h['objectClass'] = 'domain'
    return h
  end

  def <=>(domain)
    return self.domain <=> domain.alias if domain.is_a?(DomainAlias)
    self.domain <=> domain.domain
  end
end
