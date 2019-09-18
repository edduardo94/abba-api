class CreatePagarMeTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :pagar_me_transactions do |t|
      t.string :order_id
      t.string :pagarme_id

      t.timestamps
    end
  end
end
