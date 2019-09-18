class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :cpf
      t.string :gender
      t.string :birth_date
      t.string :cellphone
      t.string :phone
      t.integer :user_type, default: 1
      t.integer :host_user_id

      t.timestamps
    end
  end
end