class Role < ActiveRecord::Base
  validates :name, uniqueness: true

  has_many :assignments
  has_many :users, :through => :assignments
end
