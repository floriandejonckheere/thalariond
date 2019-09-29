# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :uuid             not null, primary key
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string           not null
#  last_name              :string
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  rights                 :string           default([]), not null, is an Array
#  sign_in_count          :integer          default(0), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ApplicationRecord
  devise :database_authenticatable, :recoverable,
         :rememberable, :validatable, :trackable

  RIGHTS = %w[
    admin
    web
  ].freeze

  ##
  # Associations
  #

  ##
  # Validations
  #
  validates :first_name,
            presence: true

  validates :email,
            presence: true,
            uniqueness: true

  validate :validate_rights_inclusion

  ##
  # Callbacks
  #

  ##
  # Methods
  #
  def full_name
    last_name? ? "#{first_name} #{last_name}" : first_name
  end

  def right?(right)
    rights.include? right
  end

  def admin?
    right? 'admin'
  end

  def web?
    right? 'web'
  end

  ##
  # Callback and validation methods
  #
  def validate_rights_inclusion
    return if rights.all? { |r| RIGHTS.include? r }

    errors.add(:rights, :must_be_included)
  end
end
