class AddInstallmentsToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :installments, :integer
  end
end
