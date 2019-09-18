class CreateBankAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :bank_accounts do |t|
      t.belongs_to :user, foreign_key: true
      t.string :agency
      t.string :account
      t.string :bank_code
      t.string :bank_name
      t.string :operation

      t.timestamps
    end
  end
end
