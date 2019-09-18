class MakeUserIdUniqueOnPoints < ActiveRecord::Migration[5.2]
  def up
    add_index(:points, [:user_id], unique: true, name: 'user_id_index')
  end
  def down
    remove_index :points, name: :user_id_index
  end
end
