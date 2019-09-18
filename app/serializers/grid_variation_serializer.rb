class GridVariationSerializer < ActiveModel::Serializer
  attributes :id, :name
  belongs_to :grid
end
