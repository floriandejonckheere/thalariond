class Role < ActiveRecord::Base
  validates :name, uniqueness: true

  has_many :assignments, -> { uniq }, :dependent => :destroy
  has_many :users, -> { uniq }, :through => :assignments
end
