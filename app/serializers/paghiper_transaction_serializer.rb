class PaghiperTransactionSerializer < ActiveModel::Serializer
  attributes :id, :url_slip, :url_slip_pdf
  belongs_to :order

end
