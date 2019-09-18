class GridSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :grid_variations
  has_many :grids_products
  has_many :products, through: :grids_products
end
