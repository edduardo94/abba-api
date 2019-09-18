class SubcategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :active
  belongs_to :category
end
