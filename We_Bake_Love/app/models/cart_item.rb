class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :cake

  before_save :set_unit_price
  before_save :set_total

  def unit_price
    if persisted?
      self[:unit_price]
    else
      cake.price
    end
  end

  def total
    unit_price * quantity
  end

  private

  def set_unit_price
    self[:unit_price] = unit_price
  end

  def set_total
    self[:total] = unit_price * quantity
  end
end
