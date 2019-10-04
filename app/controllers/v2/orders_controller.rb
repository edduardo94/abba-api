# frozen_string_literal: true

require 'pagarme'
module V2
  class OrdersController < ApplicationController
    def create
      ActiveRecord::Base.transaction do
        current_user.orders.validate_order(params.require(:stocks))
        order = current_user.orders.create!(order_params)
        params.require(:stocks).each do |j|
          stock = Stock.find(j[:stock_id])
          order.orders_stocks.create!(order_id: order.id,
                                      stock_id: j[:stock_id],
                                      quantity: j[:quantity],
                                      product_id: stock.product_id,
                                      value: stock.product.office_price)
        end
        process_payment(order)
        json_response(order)
      end
    rescue StandardError => e
      json_response(e, :unprocessable_entity)
    end

    def show
      @order = current_user.orders.find(params.require(:id))
      json_response(@order)
    end

    def index
      @orders = current_user.orders.where(order_type: [1, 2]).order(:created_at)
      json_response(@orders)
    end

    def calc_frete
      @pacote = Correios::Frete::Pacote.new
      frete_params[:products].each do |j|
        product = Product.find_by(id: j[:product_id])
        (1..j[:quantity]).each do |_i|
          item = Correios::Frete::PacoteItem.new peso: product.weight,
                                                 comprimento: product.depth,
                                                 largura: product.width,
                                                 altura: product.height
          @pacote.adicionar_item(item)
        end
      end
      frete = Correios::Frete::Calculador.new cep_origem: '61925440',
                                              cep_destino: frete_params[:cep_destino],
                                              encomenda: @pacote
      pac = frete.calcular :pac
      sedex = frete.calcular :sedex
      json_response(sedex: sedex, pac: pac)
      end

    private

    def order_params
      params.permit(
        :frete_value,
        :address_id,
        :value,
        :frete_days,
        :frete_type,
        :payment_type,
        :order_type,
        :card_detail,
        :installments
      )
    end

    def frete_params
      params.permit(
        :cep_destino,
        products: %i[
          product_id
          selected_size
          stock_id
          quantity
        ]
      )
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
        order.update!(status: 9)
        # generate_pagar_me(order)
      end
    end

    def generate_pagar_me(order)
      PagarMe.api_key = ENV['PAGAR_ME_API_KEY']
      order.user.cpf.gsub!(/(\.|\-)/, '') if order.user.cpf.length > 11
      items = []
      order.orders_stocks.each do |stock|
        items << {
          "id": stock.product.id.to_s,
          "title": stock.product.description,
          "quantity": stock.quantity,
          "unit_price": (stock.value * 100).to_i,
          "tangible": true
        }
      end
      transaction = PagarMe::Transaction.new(
        "amount": (order.value * 100).to_i,
        "payment_method": 'credit_card',
        "card_number": params[:card_detail][:number].gsub(/\s+/, ''),
        "card_holder_name": params[:card_detail][:name],
        "card_expiration_date": params[:card_detail][:expiry].gsub(%r{/}, '').gsub(/\s+/, ''),
        "card_cvv": params[:card_detail][:cvc],
        "postback_url": "#{ENV['SERVER_URL']}/pagarme_notification",
        "installments": order.installments,
        "customer": {
          "external_id": order.user.id.to_s,
          "name": order.user.name,
          "type": 'individual',
          "country": 'br',
          "email": order.user.email,
          "documents": [
            {
              "type": 'cpf',
              "number": order.user.cpf

            }
          ],
          "phone_numbers": ['+55' + order.user.cellphone.gsub(/[()]/, '').gsub(/\s+/, '').gsub!(/(\-)/, '')]

        },
        "billing": {
          "name": order.user.name,
          "address": {
            "country": 'br',
            "state": order.user.addresses.find_by(is_principal: true).state,
            "city": order.user.addresses.find_by(is_principal: true).city,
            "neighborhood": order.user.addresses.find_by(is_principal: true).neighborhood,
            "street": order.user.addresses.find_by(is_principal: true).address,
            "street_number": order.user.addresses.find_by(is_principal: true).number.to_s,
            "zipcode": order.user.addresses.find_by(is_principal: true).cep.gsub!(/(\-)/, '')
          }
        },
        "items": items,
        "metadata": {
          "order_id": order.id
        }
      )

      t = transaction.charge
      create_pagarme_transaction(t, order.id)
      order.update!(status: 9)
    end

    def generate_paghiper(order)
      order_d = Order.find(order.id)
      items = []
      order.orders_stocks.each do |stock|
        items << {
          item_id: stock.product.id,
          description: stock.product.description,
          quantity: stock.quantity,
          price_cents: (stock.value * 100).to_i
        }
      end

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
        shipping_price_cents: (order.frete_value * 100).to_i,
        shipping_methods: order.frete_type,
        type_bank_slip: 'boletoA4',
        days_due_date: 2,
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

    def create_pagarme_transaction(params, order_id)
      PagarMeTransaction.create!(pagarme_id: params.id, order_id: order_id)
    end
  end
end
