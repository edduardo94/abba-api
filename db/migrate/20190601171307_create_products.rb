class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :description
      t.integer :product_type
      t.float :price
      t.float :office_price
      t.integer :category_id
      t.integer :subcategory_id
      t.boolean :active
      t.float :unity_price
      t.float :promotional_price
      t.float :weight
      t.integer :width
      t.integer :height
      t.integer :depth
      t.string :slug

      t.timestamps
    end
  end
end
