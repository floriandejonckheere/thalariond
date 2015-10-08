class EmailAlias < ActiveRecord::Base
  validates :alias, presence: true, format: { with: /@/ }, uniqueness: true
  validates :mail, presence: true, format: { with: /@/ }

  def to_ldap
    h = {}
    h['alias'] = self.alias
    h['mail'] = self.mail
    h['objectClass'] = 'vmailAlias'
    return h
  end
end
