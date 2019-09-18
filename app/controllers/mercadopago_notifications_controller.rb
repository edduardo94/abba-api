# frozen_string_literal: true

require 'mercadopago.rb'

class MercadopagoNotificationsController < ApplicationController
  skip_before_action :authorize_request, only: :create
  include ActionController::Live
  def create
    begin
    ensure
      render status: 200
    end
    search_transaction(params)
  end

  private

  def search_transaction(params)
    $mp = MercadoPago.new(ENV['MERCADO_PAGO_ID'], ENV['MERCADO_PAGO_SECRET'])

    paymentInfo = $mp.get_payment(params[:data][:id])
    transaction =
      MercardoPagoTransaction.find_by(order_id:
        paymentInfo['response']['external_reference'])
    order = Order.find(transaction.order_id)

    if paymentInfo['response']['status'] == 'approved' || paymentInfo['response']['status'] == 'authorized'
      order.update!(status: 5)
    end

    if paymentInfo['response']['status'] == 'canceled' || paymentInfo['response']['status'] == 'rejected'
      order.update!(status: 2)
    end

    order.update!(status: 9) if paymentInfo['response']['status'] == 'pending'
    order.update!(status: 11) if paymentInfo['response']['status'] == 'in_process'
    order.update!(status: 10) if paymentInfo['response']['status'] == 'refunded'
  end
  
end
