# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :subcategories, class_name: 'Subcategory', foreign_key: 'category_id'
  has_many :products, class_name: 'Product', foreign_key: 'category_id'
end
