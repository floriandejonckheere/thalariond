class Email < ActiveRecord::Base
  has_paper_trail

  before_save :sanitize_attributes

  before_validation :create_permission_group
  before_update :update_permission_group

  belongs_to :domain, -> { uniq }

  has_one :permission_group, class_name: 'Group', dependent: :destroy, required: true

  validates :mail, presence: true, format: { with: /[^@]*/ }, length: { in: 1..64 }
  validate :validate_mail_total_length
  validates :domain, presence: true
  validates_uniqueness_of :mail, scope: :domain
  validate :validate_email_not_alias


  # Methods
  # Callbacks
  def sanitize_attributes
    self.mail.downcase!
  end

  def create_permission_group
    email = "#{self.mail}@#{self.domain.domain}"

    if Group.exists?(name: email)
      errors[:permission_group] = "already exists"
      return
    end

    group = Group.create!(:name => email,
                          :display_name => "Email account for #{email}")

    self.permission_group = group
  end

  def update_permission_group
    if mail_changed?
      permission_group.update_attributes(:name => "#{self.mail}@#{self.domain.domain}")
      permission_group.save!
    end
  end


  # Validations
  def validate_mail_total_length
    errors.add(:mail, "including domain can't be longer than 254 characters") if self.to_s.length > 254
  end

  def validate_email_not_alias
    errors.add(:mail, "can't be an email alias") if EmailAlias.find_by(alias: self.to_s)
  end

  # Overrides
  def to_s
    "#{self.mail}@#{self.domain.domain}"
  end

  def to_ldap
    h = {}
    h['mail'] = self.mail
    h['objectClass'] = 'vmail'
    return h
  end

  def <=>(email)
    return self.mail <=> email.alias if email.is_a?(EmailAlias)
    self.mail <=> email.mail
  end
end
