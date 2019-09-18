class OrderSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :value, :frete_type, :frete_value, :frete_days, :payment_type, :status

  belongs_to :address

  has_many :orders_stocks
  has_many :stocks, through: :orders_stocks
  has_one :paghiper_transaction
  has_one :mercardo_pago_transaction
  has_one :pagar_me_transaction
end
