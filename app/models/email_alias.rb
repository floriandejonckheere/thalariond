class EmailAlias < ActiveRecord::Base
  has_paper_trail

  validates :alias, presence: true, uniqueness: true
  validates :mail, presence: true
  validates_format_of :alias, :with => /\A[^@]+@[^@]+\Z/
  validates_format_of :mail, :with => /\A[^@]+@[^@]+\Z/
  validate :validate_no_loops
  validate :validate_managed_alias_domain

  def validate_no_loops
    errors.add(:mail, "can't be an email alias") unless EmailAlias.find_by(alias: self.mail).nil?
    errors.add(:alias, "can't be aliased to itself") if self.alias == self.mail
  end

  def validate_managed_alias_domain
    split = self.alias.split('@')
    domain = Domain.find_by(domain: split[1])
    errors.add(:alias, "must be a managed domain") if domain.nil?
    if (Email.find_by(mail: split[0]) and Email.find_by(mail: split[0]).domain.domain.equal?(split[1]))
      errors.add(:alias, "can't be a managed email")
    end
  end

  def to_ldap
    h = {}
    h['alias'] = self.alias
    h['mail'] = self.mail
    h['objectClass'] = 'vmailAlias'
    return h
  end

  def <=>(email_alias)
    return self.alias <=> email_alias.mail if email_alias.is_a?(Email)
    self.alias <=> email_alias.alias
  end
end
