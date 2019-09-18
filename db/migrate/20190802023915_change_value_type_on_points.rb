class ChangeValueTypeOnPoints < ActiveRecord::Migration[5.2]
  def self.up
    change_column :points, :value, :decimal, precision: 15, scale: 2
  end
 
  def self.down
    change_column :points, :value, :float
  end
end
