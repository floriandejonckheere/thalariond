# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id         :uuid             not null, primary key
#  first_name :string           not null
#  last_name  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ApplicationRecord
  ##
  # Associations
  #

  ##
  # Validations
  #
  validates :first_name,
            presence: true

  ##
  # Callbacks
  #

  ##
  # Methods
  #
  def full_name
    last_name? ? "#{first_name} #{last_name}" : first_name
  end

  ##
  # Callback methods
  #
end
