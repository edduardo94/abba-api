class Stock < ApplicationRecord
  belongs_to :product
  belongs_to :grid_variation
end
