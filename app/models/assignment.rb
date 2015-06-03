class Assignment < ActiveRecord::Base
  belongs_to :user
  belongs_to :role, inverse_of: :assignments

  validates :user, presence: true
  validates :role, presence: true
end
