class AddLevelRefToUsers < ActiveRecord::Migration[5.2]
  def change
    add_belongs_to :users, :level, foreign_key: {to_table: :levels}
  end
end
