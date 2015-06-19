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
  has_and_belongs_to_many :roles, :uniq => true

  # Groups
  has_and_belongs_to_many :groups, :uniq => true
  has_many :owned_groups, class_name: 'Group', foreign_key: 'user_id'

  ## Methods
  def has_role?(role_sym)
    roles.any? { |r| r.name.underscore.to_sym == role_sym.downcase }
  end

  def ability
    @ability ||= Ability.new(self)
  end
  delegate :can?, :cannot?, :to => :ability
end
