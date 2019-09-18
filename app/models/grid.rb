# frozen_string_literal: true

class Grid < ApplicationRecord
  has_many :grid_variations
  has_many :grids_products
  has_many :products, through: :grids_products
end
