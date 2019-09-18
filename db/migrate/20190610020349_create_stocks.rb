# frozen_string_literal: true

class CreateStocks < ActiveRecord::Migration[5.2]
  def change
    create_table :stocks do |t|
      t.integer :product_id
      t.string :size
      t.integer :quantity
      t.integer :grid_variation_id

      t.timestamps
    end
  end
end
