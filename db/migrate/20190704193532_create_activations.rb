class CreateActivations < ActiveRecord::Migration[5.2]
  def change
    create_table :activations do |t|
      t.integer :status
      t.belongs_to :user, foreign_key: true
      t.string :order_id
      

      t.timestamps
    end
  end
end
