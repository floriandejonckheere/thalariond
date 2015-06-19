class Group < ActiveRecord::Base
  validates :name, presence: true

  # Membership
  has_and_belongs_to_many :users, :unique => true

  # Ownership
  belongs_to :owner, class_name: 'User', foreign_key: 'user_id'

  # Service membership
  has_and_belongs_to_many :services, :unique => true
end
