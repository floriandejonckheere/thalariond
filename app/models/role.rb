class Role < ActiveRecord::Base
  validates :name, uniqueness: true

  has_and_belongs_to_many :users, :unique => true
  has_and_belongs_to_many :services, :unique => true

end
