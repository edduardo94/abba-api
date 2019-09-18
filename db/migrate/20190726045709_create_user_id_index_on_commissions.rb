class CreateUserIdIndexOnCommissions < ActiveRecord::Migration[5.2]
  def up
    add_index(:commissions, [:user_id], unique: true, name: 'commissions_user_id_index')
  end
  def down
    remove_index :commissions, name: :commissions_user_id_index
  end
end
