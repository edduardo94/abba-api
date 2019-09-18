class ProductSerializer < ActiveModel::Serializer
  attributes :id, :description, :price, :slug, :promotional_price
  has_many :stocks  
end
