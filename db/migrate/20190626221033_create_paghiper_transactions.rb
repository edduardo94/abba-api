# frozen_string_literal: true

class CreatePaghiperTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :paghiper_transactions do |t|
      t.string :transaction_id
      t.integer :value_cents
      t.string :status
      t.string :order_id
      t.date :due_date
      t.string :digitable_line
      t.string :url_slip
      t.string :url_slip_pdf
      t.timestamp :created_date

      t.timestamps
    end
  end
end
