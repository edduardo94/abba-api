class Admin::GridSerializer < ActiveModel::Serializer
  attributes :id, :name, :grid_variations
  has_many :grid_variations, serializer: Admin::GridVariationSerializer
end
