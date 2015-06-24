class Email < ActiveRecord::Base
  validates :mail, presence: true

  belongs_to :domain, -> { uniq }

  validates_uniqueness_of :mail, scope: :domain
end
