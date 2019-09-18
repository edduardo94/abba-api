class OrdersStockSerializer < ActiveModel::Serializer
  attributes :id, :stock_id, :quantity, :value, :product, :stock
  belongs_to :product
  belongs_to :stock
end
