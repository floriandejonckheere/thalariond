class EmailAlias < ApplicationRecord
  has_paper_trail

  before_save :sanitize_attributes

  validates :alias, presence: true, uniqueness: true
  validates :mail, presence: true
  validates_format_of :alias, :with => /\A[^@]+@[^@]+\Z/, length: { in: 3..254 }
  validates_format_of :mail, :with => /\A[^@]+@[^@]+\Z/, length: { in: 3..254 }
  validate :validate_mail_total_length
  validate :validate_domain_length
  validate :validate_no_loops
  validate :validate_managed_alias_domain
  validate :validate_no_emails


  # Methods
  # Callbacks
  def sanitize_attributes
    self.alias.downcase!
    self.mail.downcase!
  end


  # Validations
  def validate_mail_total_length
    errors.add(:alias_local_part, "can't be longer than 64 characters") if self.alias.split('@')[0].length > 64
    errors.add(:mail_local_part, "can't be longer than 64 characters") if self.mail.split('@')[0].length > 64
  end

  def validate_domain_length
    return if self.alias.split('@')[1].nil?
    return if self.mail.split('@')[1].nil?
    errors.add(:alias_domain, "can't be longer than 253 characters") if self.alias.split('@')[1].length > 253
    errors.add(:mail_domain, "can't be longer than 253 characters") if self.mail.split('@')[1].length > 253
  end

  def validate_no_loops
    errors.add(:mail, "can't be an email alias") unless EmailAlias.find_by(alias: self.mail).nil?
    errors.add(:alias, "can't be aliased to itself") if self.alias == self.mail
  end

  def validate_managed_alias_domain
    split = self.alias.split '@'
    domain = Domain.find_by(domain: split[1])
    errors.add(:alias, "must be a managed domain") if domain.nil?
    if (Email.find_by(mail: split[0]) and Email.find_by(mail: split[0]).domain.domain.equal?(split[1]))
      errors.add(:alias, "can't be a managed email")
    end
  end

  def validate_no_emails
    split = self.alias.split '@'
    domain = Domain.find_by :domain => split.last
    if domain and domain.emails.exists?(:mail => split.first)
      errors.add :alias, "already exists as an email"
    end
  end


  # Overrides
  def to_ldap
    h = {}
    h['alias'] = self.alias
    h['mail'] = self.mail
    h['objectClass'] = 'mailAliasAccount'
    return h
  end

  def <=>(email_alias)
    return self.alias <=> email_alias.mail if email_alias.is_a?(Email)
    self.alias <=> email_alias.alias
  end
end
