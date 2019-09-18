class ChangeValueTypeOnWallets < ActiveRecord::Migration[5.2]
  def self.up
    change_column :wallets, :value, :decimal, precision: 15, scale: 2
  end
 
  def self.down
    change_column :wallets, :value, :float
  end
end
