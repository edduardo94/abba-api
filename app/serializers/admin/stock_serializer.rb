class Admin::StockSerializer < ActiveModel::Serializer
  attributes :id, :quantity, :size, :grid_variation
  belongs_to :product
  belongs_to :grid_variation
end
