class AuthEvent < ActiveRecord::Base
  before_save :generate_timestamp

  belongs_to :user

  validates :component, :inclusion => { :in => ["http", "ldap"] }
  validates :action, :inclusion => { :in => ["signin", "signout"] }

  def generate_timestamp
    self.timestamp = DateTime.now
  end
end
