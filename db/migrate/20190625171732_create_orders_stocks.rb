# frozen_string_literal: true

class CreateOrdersStocks < ActiveRecord::Migration[5.2]
  def change
    create_table :orders_stocks do |t|
      t.belongs_to :stock
      t.string :order_id
      t.integer :quantity
      t.belongs_to :product
      t.float :value
      
      t.index :order_id
      t.timestamps
    end
  end
end
