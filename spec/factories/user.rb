# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    ##
    # Attributes
    #
    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }
    email { FFaker::Internet.email }
    password { 'password1' }
  end
end
