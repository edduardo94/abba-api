# frozen_string_literal: true

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

# #######PAYMENT#######
# 1 boleto
# 2 deposito
# 3 creditCard

# #######TYPE#######
# 1 sale
# 2 activation
# 3 manual activation

require 'cpf_cnpj'

class Order < ApplicationRecord
  belongs_to :address
  belongs_to :user
  has_one :paghiper_transaction
  has_one :mercardo_pago_transaction
  has_one :pagar_me_transaction
  has_many :orders_stocks
  has_many :stocks, through: :orders_stocks

  scope :this_month, lambda {
    where(created_at:
      Time.parse('2019-09-10')..Time.parse('2019-10-10'))
  }

  before_create :set_uuid, :set_type
  before_update :check_status_update
  after_update :verify_stock, :do_points,
               :do_bonus_networking, :do_activate_bonus, :do_referral_bonus_job

  validate :verify_activation
  validate :verify_cpf

  def self.validate_order(stocks)
    stocks.each do |i|
      stock = Stock.find(i[:stock_id])
      if stock.quantity < i[:quantity]
        raise 'Pedido com produtos indisponiveis no estoque ' + ' Produto: ' + stock.product.description + ' Quantidade solicitada: ' + i[:quantity].to_s + ' quantidade disponivel: ' + stock.quantity.to_s
      end
    end
  end

  def set_type
    self.order_type = 2 unless user.first_activated?
  end

  def set_uuid
    self.id = SecureRandom.uuid
  end

  def is_cancelled
    status.to_i == 2
  end

  def is_paid
    status.to_i == 5
  end

  private

  def verify_activation
    # activation_value = if user.user_type == 2
    #                      500
    #                    elsif user.user_type == 3
    #                      1000
    #                    elsif user.user_type == 4
    #                      2000
    #                    end

    # if !user.first_activated? && value - frete_value < activation_value
    #   raise 'Para concluir sua ativação o valor dos seus produtos precisa ser superior a ' + helper.number_to_currency(activation_value, unit: 'R$ ', separator: ',', delimiter: '.')
    # end

    if !user.activated? && (value - frete_value) < 210
      raise 'Para concluir sua ativação o valor dos seus produtos precisa ser superior a R$ 210,00'
    end
  end

  def verify_cpf
    if user.cpf.length > 11
      raise 'CPF inválido, por favor verifique seu cpf no cadastro!' unless CPF.valid?(user.cpf.gsub!(/(\.|\-)/, ''))
    else
      raise 'CPF inválido, por favor verifique seu cpf no cadastro!' unless CPF.valid?(user.cpf)
    end
  end

  def check_status_update  
    if status_was.to_i == 5 && ![2, 3, 4, 6, 7, 8, 10, 12, 13].include?(status.to_i)
      raise 'Mudança de status não permitida'
    end
  end

  def do_points
    point = user.point
    if is_paid && !points_released
      puts "PEDIDO: ##{id} R$ #{value}| USUARIO: #{user.id} | ADD PONTOS #{value}"
      point.update(value: point.value + (value - frete_value))
      update_column :points_released, true
    elsif is_cancelled && points_released
      puts "PEDIDO: ##{id} R$ #{value}| USUARIO: #{user.id} | REMOVER PONTOS #{value}"
      point.update(value: point.value - (value - frete_value))
      update_column :points_released, false
    end
  end

  def do_bonus_networking    
    if user.host
      if is_paid && !commission_released 
        puts "PEDIDO: ##{id} R$ #{value}| USUARIO: #{user.id} | ADD BONUS DE REDE #{value}"
        job = BonusNetworkingJob.new(user.host, value - frete_value)
        job.run
        update_column :commission_released, true
      elsif is_cancelled && commission_released
        puts "PEDIDO: ##{id} R$ #{value}| USUARIO: #{user.id} | REMOVER BONUS DE REDE #{value}"
        job = BonusNetworkingJob.new(user.host, (value - frete_value) * -1)
        job.run
        update_column :commission_released, false
      end
    end
  end

  def do_activate_bonus
    if user.host
      if is_paid && first_payed_month_order?
        job = BonusActivationJob.new(user.host, 1)
        job.run
      end
    end
  end

  def do_referral_bonus_job
    #comenta isso aqui por enquanto
    # if user.host && is_indication
    #   if is_paid
    #     job = BonusReferralJob.new(user.host, user.user_type, 1)
    #     job.run
    #   end
    # end
  end

  def first_payed_month_order?
    orders = user.orders.where(created_at:
      Time.now.beginning_of_month..Time.now.end_of_month)
    array = []
    orders.each do |order|
      array.push(order) if [3, 4, 5, 6, 7, 8].include?(order.status)
    end
    if array.size == 1
      return true
    else
      return false
    end
  end

  def verify_stock
    restore_stock if is_cancelled
  end

  def restore_stock
    orders_stocks.each(&:restore_stock)
  end

  def is_indication
    order_type == 2
  end

  def helper
    @helper ||= Class.new do
      include ActionView::Helpers::NumberHelper
    end.new
  end
end
