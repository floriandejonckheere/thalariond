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

require 'rails_helper'

RSpec.describe User, type: :model do
  ##
  # Configuration
  #

  ##
  # Stubs and mocks
  #

  ##
  # Subject
  #
  subject(:user) { create :user }

  ##
  # Test variables
  #

  ##
  # Tests
  #
  it { is_expected.to validate_presence_of :first_name }

  describe '#full_name' do
    it 'returns the full name' do
      expect(user.full_name).to eq "#{user.first_name} #{user.last_name}"
    end
  end
end
