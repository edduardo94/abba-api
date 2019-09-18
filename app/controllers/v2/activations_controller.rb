# frozen_string_literal: true

require 'mercadopago.rb'
module V2
  class ActivationsController < ApplicationController
    def create
      ActiveRecord::Base.transaction do
        address_id = current_user.addresses.where(is_principal: true).first.id
        order = {}
        # TODO: ajeitar isso aqui mes q vem
        # if !current_user.activations.empty? && first_activated?
        #   order = current_user.orders.create(value: 210, payment_type:
        #                                      activation_params[:payment_type],
        #                                      order_type: 2,
        #                                      address_id: address_id)
        # else

        #   if current_user.user_type == 2
        #     order = current_user.orders.create(value: 500, payment_type:
        #                                        activation_params[:payment_type],
        #                                        order_type: 2,
        #                                        address_id: address_id)
        #   elsif current_user.user_type == 3
        #     order = current_user.orders.create(value: 1000, payment_type:
        #       activation_params[:payment_type],
        #                                        order_type: 2,
        #                                        address_id: address_id)
        #   end
        # end

        order = current_user.orders.create(value: 210, payment_type:
                                           activation_params[:payment_type],
                                           order_type: 2,
                                           address_id: address_id)
        process_payment(order)
        activation = current_user.activations.create!(order_id: order.id)
        json_response(activation)
      end
    end

    def index
      activations = current_user.activations
      json_response(activations)
    end

    def show
      activation = current_user.activations.find(activation_params[:id])
      order = current_user.orders.find(activation.order.id)
      payment = load_payment(order) if order.id
      object = {
        activation: activation,
        order: order,
        payment: payment
      }
      json_response(object)
    end

    def activation_status
      activated = current_user.activated?
      json_response(status: activated)
    end

    private

    def month_activated; end

    def load_payment(order)
      case order.payment_type.to_i
      when 1
        PaghiperTransaction.find(order.paghiper_transaction.id)
      when 2
        2
      when 3
        MercardoPagoTransaction.find(order.mercardo_pago_transaction.id)
      end
    end

    def activation_params
      params.permit(:payment_type, :id)
    end

    def process_payment(order)
      case order.payment_type.to_i
      when 1
        generate_paghiper(order)
      when 2
        order.update!(status: 9)
      when 3
        generate_mercado_pago(order)
      end
    end

    def generate_mercado_pago(order)
      $mp = MercadoPago.new(ENV['MERCADO_PAGO_ID'], ENV['MERCADO_PAGO_SECRET'])
      order_d = Order.find(order.id)
      preference_data = {
        items: [
          {
            title: 'Ativação mensal',
            quantity: 1,
            unit_price: order.value,
            currency_id: 'BRL'
          }
        ],
        payment_methods: {
          excluded_payment_types: [{ "id": 'ticket' }]
        },
        external_reference: order_d.id

      }
      preference = $mp.create_preference(preference_data)
      create_mercado_pago_transaction(preference, order_d.id)
      order_d.update(status: 9)
    end

    def generate_paghiper(order)
      order_d = Order.find(order.id)
      items = []
      items << {
        item_id: 0,
        description: 'Ativação mensal',
        quantity: 1,
        price_cents: 100 * order_d.value
      }

      transaction_data = {
        apiKey: ENV['PAGHIPER_KEY'],
        order_id: order_d.id,
        payer_email: order_d.user.email,
        payer_name: order_d.user.name,
        payer_cpf_cnpj: order_d.user.cpf,
        payer_phone: order_d.user.cellphone,
        payer_street: order_d.user.addresses.where(is_principal: true).first.address,
        payer_number: order_d.user.addresses.where(is_principal: true).first.number,
        payer_complement: order_d.user.addresses.where(is_principal: true).first.complement,
        payer_district: order_d.user.addresses.where(is_principal: true).first.neighborhood,
        payer_city: order_d.user.addresses.where(is_principal: true).first.city,
        payer_state: order_d.user.addresses.where(is_principal: true).first.state,
        payer_zip_code: order_d.user.addresses.where(is_principal: true).first.cep,
        notification_url: ENV['SERVER_URL'] + '' + '/paghiper_notification',
        fixed_description: false,
        type_bank_slip: 'boletoA4',
        days_due_date: 6,
        items: items

      }
      transaction = Paghiper::Transaction.create(transaction_data)
      create_paghiper_transaction(transaction, order_d.id)
      order_d.update!(status: 9)
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
