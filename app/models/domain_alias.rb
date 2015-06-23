class DomainAlias < ActiveRecord::Base
  validates :alias, presence: true, uniqueness: true
  validates :domain, presence: true
end
