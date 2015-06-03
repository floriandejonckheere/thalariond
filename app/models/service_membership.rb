class ServiceMembership < ActiveRecord::Base
  belongs_to :service
  belongs_to :group, inverse_of: :service_memberships
end
