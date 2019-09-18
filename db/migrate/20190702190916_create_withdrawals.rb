class CreateWithdrawals < ActiveRecord::Migration[5.2]
  def change
    create_table :withdrawals do |t|
      t.float :value
      t.belongs_to :user, foreign_key: true
      t.integer :status

      t.timestamps
    end
  end
end
