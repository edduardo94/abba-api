class AddNameAndCpfToBankAccounts < ActiveRecord::Migration[5.2]
  def change
    add_column :bank_accounts, :name, :string
    add_column :bank_accounts, :cpf, :string
  end
end
