class ChangeOfficePriceTypeOnProducts < ActiveRecord::Migration[5.2]
  def self.up
    change_column :products, :office_price, :decimal, precision: 15, scale: 2
  end
 
  def self.down
    change_column :products, :office_price, :float
  end
end
