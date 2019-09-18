class ChangeValueTypeOnOrdersStock < ActiveRecord::Migration[5.2]
  def self.up
    change_column :orders_stocks, :value, :decimal, precision: 15, scale: 2
  end
 
  def self.down
    change_column :orders_stocks, :value, :float
  end
end
