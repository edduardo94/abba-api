class CreateVariationIndexOnGridProducts < ActiveRecord::Migration[5.2]
  def up
    add_index(:grids_products, [:product_id, :grid_id], unique: true, name: 'grid_product_index')
  end
  def down
    remove_index :grids_products, name: :grid_product_index
  end
end
