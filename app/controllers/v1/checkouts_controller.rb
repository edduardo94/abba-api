# frozen_string_literal: true

require 'mercadopago.rb'
module V1
  class CheckoutsController < ApplicationController
    def process_payment
      case Order.find(payment_params[:order_id]).payment_type.to_i
      when 1
        generate_paghiper(payment_params[:order_id])
      when 2
        Order.find(payment_params[:order_id]).update!(status: 9)
      when 3
        generate_mercado_pago(payment_params[:order_id])
      end
    end

    private

    def payment_params
      params.permit(:order_id, :payment_type)
    end

    def generate_mercado_pago(order_id)
      $mp = MercadoPago.new(ENV['MERCADO_PAGO_ID'], ENV['MERCADO_PAGO_SECRET'])
      order = Order.find(order_id)

      preference_data = {
        items: [
          {
            title: 'Pagamento de produtos vendidos pela Hasum',
            quantity: 1,
            unit_price: order.value,
            currency_id: 'BRL'
          }
        ],
        payment_methods: {
          excluded_payment_types: [{ "id": 'ticket' }]
        },
        external_reference: order.id

      }
      preference = $mp.create_preference(preference_data)
      create_mercado_pago_transaction(preference, order_id)
      Order.find(order_id).update(status: 9)
      json_response(preference)
    end

    def generate_paghiper(order_id)
      order = Order.find(order_id)
      items = []
      order.stocks.each do |stock|
        items << {
          item_id: stock.product.id,
          description: stock.product.description,
          quantity: order.orders_stocks.find_by(stock_id: stock.id).quantity,
          price_cents: 100 * (stock.product.promotional_price || stock.product.price)
        }
      end

      transaction_data = {
        apiKey: ENV['PAGHIPER_KEY'],
        order_id: order_id,
        payer_email: order.user.email,
        payer_name: order.user.name,
        payer_cpf_cnpj: order.user.cpf,
        payer_phone: order.user.cellphone,
        payer_street: order.user.addresses.where(is_principal: true).first.address,
        payer_number: order.user.addresses.where(is_principal: true).first.number,
        payer_complement: order.user.addresses.where(is_principal: true).first.complement,
        payer_district: order.user.addresses.where(is_principal: true).first.neighborhood,
        payer_city: order.user.addresses.where(is_principal: true).first.city,
        payer_state: order.user.addresses.where(is_principal: true).first.state,
        payer_zip_code: order.user.addresses.where(is_principal: true).first.cep,
        notification_url: ENV['SERVER_URL'] + '' + '/paghiper_notification',
        shipping_price_cents: 100 * order.frete_value,
        shipping_methods: order.frete_type,
        fixed_description: false,
        type_bank_slip: 'boletoA4',
        days_due_date: 6,
        items: items

      }
      transaction = Paghiper::Transaction.create(transaction_data)
      create_paghiper_transaction(transaction, order_id)
      Order.find(order_id).update!(status: 9)
      json_response(transaction)
    end

    def create_paghiper_transaction(params, order_id)
      PaghiperTransaction.create!(transaction_id: params[:transaction_id],
                                  value_cents: params[:value_cents],
                                  status: params[:status],
                                  order_id: order_id,
                                  due_date: params[:due_date],
                                  digitable_line: params[:bank_slip][:digitable_line],
                                  url_slip: params[:bank_slip][:url_slip],
                                  url_slip_pdf: params[:bank_slip][:url_slip_pdf],
                                  created_date: params[:bank_slip][:created_date])
    end

    def create_mercado_pago_transaction(params, order_id)
      MercardoPagoTransaction.create!(date_created: params['response']['date_created'],
                                      mercado_pago_transaction_id: params['response']['id'],
                                      init_point: params['response']['init_point'],
                                      sandbox_init_point: params['response']['sandbox_init_point'],
                                      order_id: order_id)
    end
  end
end
