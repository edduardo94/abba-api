class Subcategory < ApplicationRecord
  belongs_to :category
  has_many :products, class_name: 'Product', foreign_key: 'subcategory_id'
end
