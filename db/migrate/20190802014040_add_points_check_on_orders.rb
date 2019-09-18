class AddPointsCheckOnOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :points_released, :boolean
  end
end