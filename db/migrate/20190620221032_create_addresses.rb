class CreateAddresses < ActiveRecord::Migration[5.2]
  def change
    create_table :addresses do |t|
      t.string :cep
      t.string :address
      t.integer :number
      t.string :neighborhood
      t.string :city
      t.string :complement
      t.string :state
      t.boolean :is_principal
      t.belongs_to :user

      t.timestamps
    end
  end
end
