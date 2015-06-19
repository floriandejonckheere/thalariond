class Service < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
          :trackable

  # Properties
  validates :uid, presence: true, uniqueness: true
  validates :display_name, presence: true

  # Groups
  has_and_belongs_to_many :groups, :unique => true
end
