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
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

  describe '#full_name' do
    it 'returns the full name' do
      expect(user.full_name).to eq "#{user.first_name} #{user.last_name}"
    end
  end

  describe '#right?' do
    it 'validates that the user has the right' do
      expect(build :user, rights: %w[admin web]).to be_right 'admin'
      expect(build :user, rights: %w[admin web]).to be_right 'web'
      expect(build :user, rights: %w[web]).not_to be_right 'admin'
    end
  end

  describe '#admin?' do
    it 'validates that the user has the `admin` right' do
      expect(build :user, rights: %w[admin web]).to be_admin
      expect(build :user, rights: %w[web]).not_to be_admin
    end
  end

  describe '#web?' do
    it 'validates that the user has the `web` right' do
      expect(build :user, rights: %w[admin web]).to be_web
      expect(build :user, rights: %w[admin]).not_to be_web
    end
  end

  describe '#validate_rights_inclusion' do
    it 'validates that all rights are included in the predefined rights' do
      expect(build(:user, rights: %w[admin web])).to be_valid
      expect(build(:user, rights: %w[admin foo])).not_to be_valid
    end
  end
end
