class EmailAlias < ActiveRecord::Base
  validates :alias, presence: true, format: { with: /@/ }, uniqueness: true
  validates :mail, presence: true, format: { with: /@/ }
end
