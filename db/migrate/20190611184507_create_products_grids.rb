class CreateProductsGrids < ActiveRecord::Migration[5.2]
  def change
    create_table :grids_products do |t|
      t.belongs_to :product
      t.belongs_to :grid
    end
  end
end
