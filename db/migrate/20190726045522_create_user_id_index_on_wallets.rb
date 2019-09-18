class CreateUserIdIndexOnWallets < ActiveRecord::Migration[5.2]
  def up
    add_index(:wallets, [:user_id], unique: true, name: 'wallets_user_id_index')
  end
  def down
    remove_index :wallets, name: :wallets_user_id_index
  end
end
