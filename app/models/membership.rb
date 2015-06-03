class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :group, inverse_of: :memberships

  validates :user, presence: true
  validates :role, presence: true
end
