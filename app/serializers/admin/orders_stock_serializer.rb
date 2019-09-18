class Admin::OrdersStockSerializer < ActiveModel::Serializer
  attributes :id, :quantity, :value, :product, :grid_variation, :grid
  belongs_to :stock
  belongs_to :product

  def grid_variation
    object.stock.grid_variation
  end

  def grid
    object.stock.grid_variation.grid
  end
end
