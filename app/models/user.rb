class User < ActiveRecord::Base
  include Gravtastic
  gravtastic

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable,
          :trackable, :validatable, :lockable

  # Validations
  validates :uid, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :first_name, presence: true

  # Role-based ACL
  has_many :assignments, -> { uniq }, :dependent => :destroy
  has_many :roles, -> { uniq }, :through => :assignments

  def has_role?(role_sym)
    roles.any? { |r| r.name.underscore.to_sym == role_sym.downcase }
  end

  # Groups
  has_many :memberships, -> { uniq }, :dependent => :destroy
  has_many :groups, -> { uniq }, :through => :memberships

  has_many :ownerships, class_name: 'Membership'
  has_many :owned_groups, through: :ownerships, source: :group
end
