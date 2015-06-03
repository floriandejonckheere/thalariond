class Group < ActiveRecord::Base
  validates :name, presence: true

  # Membership
  has_many :memberships, -> { uniq }, :dependent => :destroy
  has_many :users, -> { uniq }, :through => :memberships

  # Ownership
  has_one :ownership, class_name: 'Membership'
  has_one :owner, through: :ownership, source: :user

  # Service membership
  has_many :service_memberships, -> { uniq }, :dependent => :destroy
  has_many :services, -> { uniq }, :through => :service_memberships
end
