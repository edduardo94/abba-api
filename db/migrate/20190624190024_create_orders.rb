# frozen_string_literal: true

class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders, id: false do |t|
      t.string :id, limit: 36, primary_key: true, null: false
      t.float :value
      t.belongs_to :user
      t.float :frete_value
      t.integer :frete_days
      t.string :frete_type
      t.string :payment_type
      t.integer :address_id
      t.integer :status, default: 1

      t.timestamps
    end
  end
end
