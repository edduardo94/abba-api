class ChangeValueTypeOnOrders < ActiveRecord::Migration[5.2]
  def self.up
    change_column :orders, :value, :decimal, precision: 15, scale: 2
  end
 
  def self.down
    change_column :orders, :value, :float
  end
end
