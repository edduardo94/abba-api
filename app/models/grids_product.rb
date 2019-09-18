class GridsProduct < ApplicationRecord
  belongs_to :grid
  belongs_to :product
end