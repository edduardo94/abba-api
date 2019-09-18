class AddComissionCheckOnOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :commission_released, :boolean
  end
end
