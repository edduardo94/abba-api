class CategorySerializer < ActiveModel::Serializer
  attributes :id, :name, :subcategories, :active
  has_many :subcategories, class_name: 'Subcategory', foreign_key: 'category_id'  
end
