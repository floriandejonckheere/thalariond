# frozen_string_literal: true

class Role < ApplicationRecord
  validates :name, :uniqueness => true

  has_and_belongs_to_many :users,
                          :unique => true
  has_and_belongs_to_many :services,
                          :unique => true

  def <(other)
    return nil unless order && other.order

    order < other.order
  end

  def >(other)
    return nil unless order && other.order

    order > other.order
  end

  def <=(other)
    return nil unless order && other.order

    order <= other.order
  end

  def >=(other)
    return nil unless order && other.order

    order >= other.order
  end

  def ==(other)
    return nil unless order && other.order

    order == other.order
  end

  def !=(other)
    return nil unless order && other.order

    order != other.order
  end

  def <=>(other)
    return -1 if self < role
    return 0 if self == role
    return 1 if self > role

    nil
  end
end
