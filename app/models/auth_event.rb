class AuthEvent < ActiveRecord::Base

  before_save :generate_timestamp

  validates :component, :inclusion => { :in => ["http", "ldap"] }
  validates :action, :inclusion => { :in => ["signin"] }

  def generate_timestamp
    self.timestamp = DateTime.now
  end
end
