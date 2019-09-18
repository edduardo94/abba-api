class AddBankAccountIdToWithDrawals < ActiveRecord::Migration[5.2]
  def change
    add_column :withdrawals, :bank_account_id, :integer
  end
end
