class Domain < ActiveRecord::Base
  validates :domain, presence: true, uniqueness: true

  has_many :emails, -> { uniq }, :dependent => :destroy
end
