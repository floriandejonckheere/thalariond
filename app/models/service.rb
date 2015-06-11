class Service < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
          :trackable, :lockable

  # Properties
  validates :uid, presence: true, uniqueness: true
  validates :display_name, presence: true

  # Groups
  has_many :service_memberships, -> { uniq }, :dependent => :destroy
  has_many :groups, -> { uniq }, :through => :service_memberships
end
