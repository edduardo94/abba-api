class CreateVariationIndexOnOrderStocks < ActiveRecord::Migration[5.2]
  def up
    add_index(:orders_stocks, [:order_id, :stock_id, :product_id], unique: true, name: 'variation_product_index')
  end
  def down
    remove_index :orders_stocks, name: :variation_product_index
  end
end
