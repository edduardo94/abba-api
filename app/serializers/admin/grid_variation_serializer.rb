class Admin::GridVariationSerializer < ActiveModel::Serializer
  attributes :id, :name, :grid_id, :stock
  has_one :stock
end
