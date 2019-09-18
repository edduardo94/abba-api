# frozen_string_literal: true

class OrdersStock < ApplicationRecord
  belongs_to :order
  belongs_to :stock
  belongs_to :product

  before_create :deacrease_stock

  def deacrease_stock
    stock.update(quantity: stock.quantity - quantity)
  end

  def restore_stock
    stock.update(quantity: stock.quantity + quantity)
  end
end