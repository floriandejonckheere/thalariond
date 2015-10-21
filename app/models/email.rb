class Email < ActiveRecord::Base
  has_paper_trail

  before_save :sanitize_attributes

  before_create :create_permission_group
  before_save :update_permission_group

  belongs_to :domain, -> { uniq }

  validates :mail, presence: true, format: { with: /[^@]*/ }, length: { in: 1..64 }
  validates :validate_mail_total_length
  validates :domain, presence: true
  validates_uniqueness_of :mail, scope: :domain
  validate :validate_email_not_alias


  # Methods
  def permission_group
    Group.find_by(name: self.to_s)
  end


  # Callbacks
  def sanitize_attributes
    self.mail.downcase!
  end

  def create_permission_group
    email = "#{self.mail}@#{self.domain.domain}"
    group = Group.create!(:name => email,
                          :display_name => "Email account for #{email}")
    # Grant all 'mail' services access
    Role.find_by(name: 'mail').services.each do |s|
      s.groups << group
    end
  end

  def update_permission_group
    if mail_changed?
      group = Group.find_by(name: "#{self.mail_was}@#{self.domain.domain}")
      unless group.nil?
        group.update_attributes(:name => "#{self.mail}@#{self.domain.domain}")
        group.save!
      end
    end
    true
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
