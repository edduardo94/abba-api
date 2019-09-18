class Admin::OrderSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :value, :frete_type, :frete_value, :frete_days, :payment_type, :status, :order_type, :tracking_code, :is_cancelled

  belongs_to :address
  belongs_to :user

  has_many :orders_stocks, serializer: Admin::OrdersStockSerializer
  has_one :paghiper_transaction
  has_one :mercardo_pago_transaction
end
