class Admin::SubcategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :active, :category_id, :category
end
