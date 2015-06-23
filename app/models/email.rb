class Email < ActiveRecord::Base
  validates :mail, presence: true

  belongs_to :domain, -> { uniq }
end
