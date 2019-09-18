class GridVariation < ApplicationRecord
  belongs_to :grid
  has_one :stock
end
