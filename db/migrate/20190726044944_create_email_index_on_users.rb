class CreateEmailIndexOnUsers < ActiveRecord::Migration[5.2]
  def up
    add_index(:users, [:email], unique: true, name: 'user_email_index')
  end
  def down
    remove_index :users, name: :user_email_index
  end
end
