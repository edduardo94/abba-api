class AddNetworkingPointsToPoints < ActiveRecord::Migration[5.2]
  def up
    add_column :points, :networking_points, :float
  end
  def down
    remove_column :points, :networking_points
  end
end
