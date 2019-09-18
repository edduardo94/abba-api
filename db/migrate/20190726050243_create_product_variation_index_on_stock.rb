class CreateProductVariationIndexOnStock < ActiveRecord::Migration[5.2]
  def up
    add_index(:stocks, [:product_id, :grid_variation_id], unique: true, name: 'product_variation_index')
  end
  def down
    remove_index :stocks, name: :product_variation_index
  end
end
