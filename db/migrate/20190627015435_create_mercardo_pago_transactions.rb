class CreateMercardoPagoTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :mercardo_pago_transactions do |t|
      t.string :date_created
      t.string :mercado_pago_transaction_id
      t.string :init_point
      t.string :sandbox_init_point
      t.string :order_id
      
      t.timestamps
    end
  end
end
