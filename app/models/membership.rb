class Membership < ActiveRecord::Base
  belongs_to :user
  belongs_to :group, inverse_of: :memberships
end
