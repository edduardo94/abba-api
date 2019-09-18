class AddTrackingCodeToOrders < ActiveRecord::Migration[5.2]
  def up
    add_column :orders, :tracking_code, :string
  end
  def down
    remove_column :orders, :tracking_code
  end
end
