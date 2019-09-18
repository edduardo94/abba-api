# frozen_string_literal: true

class Product < ApplicationRecord
  include Filterable
  has_many_attached :images
  
  belongs_to :category
  belongs_to :subcategory

  has_many :stocks, class_name: 'Stock', foreign_key: 'product_id'

  has_many :grids_products
  has_many :grids, through: :grids_products

  # default_scope { includes(:chapters) }

  scope :with_eager_loaded_images, -> { eager_load(images_attachments: :blob) }
  scope :category, ->(category_id) { where category_id: category_id }
  scope :subcategory, ->(subcategory_id) { where subcategory_id: subcategory_id }  
  scope :starts_with, -> (name) { where("description like ?", "#{name}%")}
end
