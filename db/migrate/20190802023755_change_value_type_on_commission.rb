class ChangeValueTypeOnCommission < ActiveRecord::Migration[5.2]
  def self.up
    change_column :commissions, :value, :decimal, precision: 15, scale: 2
  end
 
  def self.down
    change_column :commissions, :value, :float
  end
end
