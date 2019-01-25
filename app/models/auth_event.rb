# frozen_string_literal: true

class AuthEvent < ApplicationRecord
  before_save :generate_timestamp

  belongs_to :user

  validates :component,
            :inclusion => { :in => ['http'] }
  validates :action,
            :inclusion => { :in => %w[signin signout] }

  def generate_timestamp
    self.timestamp = DateTime.now
  end
end
