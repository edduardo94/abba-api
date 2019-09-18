class MercardoPagoTransactionSerializer < ActiveModel::Serializer
  attributes :id, :init_point, :date_created, :updated_at
  belongs_to :order
end
