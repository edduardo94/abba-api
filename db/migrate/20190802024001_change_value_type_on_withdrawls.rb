class ChangeValueTypeOnWithdrawls < ActiveRecord::Migration[5.2]
  def self.up
    change_column :withdrawals, :value, :decimal, precision: 15, scale: 2
  end
 
  def self.down
    change_column :withdrawals, :value, :float
  end
end
