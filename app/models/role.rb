class Role < ApplicationRecord
  validates :name, uniqueness: true

  has_and_belongs_to_many :users, :unique => true
  has_and_belongs_to_many :services, :unique => true

  def <(role)
    return nil unless self.order and role.order
    return self.order < role.order
  end

  def >(role)
    return nil unless self.order and role.order
    return self.order > role.order
  end

  def <=(role)
    return nil unless self.order and role.order
    return self.order <= role.order
  end

  def >=(role)
    return nil unless self.order and role.order
    return self.order >= role.order
  end

  def ==(role)
    return nil unless self.order and role.order
    return self.order == role.order
  end

  def !=(role)
    return nil unless self.order and role.order
    return self.order != role.order
  end

  def <=>(role)
    return -1 if self < role
    return 0 if self == role
    return 1 if self > role
    return nil
  end
end
