class Activation < ApplicationRecord
  # #######STATUS#######
# 1 Pedido Efetuado,
# 2 Pedido Cancelado,
# 3 Pedido Entregue,
# 4 Pedido Enviado,
# 5 Pedido Pago,
# 6 Em produção,
# 7 Pedido em separação,
# 8 Pedido pronto para retirada,
# 9 Aguardando pagamento,
# 10 Pagamento devolvido,
# 11 Pagamento em análise,
# 12 Pagamento em chargeback,
# 13 Pagamento em disputa

  belongs_to :user
  belongs_to :order

  scope :this_month, -> { where(created_at: Time.now.beginning_of_month..Time.now.end_of_month) }

  
end
