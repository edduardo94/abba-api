# frozen_string_literal: true

class V1::OrdersController < ApplicationController
  def create
    if current_user.orders.validate_order(params.require(:stocks))
      ActiveRecord::Base.transaction do
        order_params[:order_type] = 1
        @order = current_user.orders.create!(order_params)
        params.require(:stocks).each do |j|
          stock = Stock.find(j[:stock_id])
          @order.orders_stocks.create!(order_id: @order.id,
                                       stock_id: j[:stock_id],
                                       quantity: j[:quantity],
                                       product_id: stock.product_id,
                                       value: stock.product.promotional_price || stock.product.price)
        end

        json_response(@order)
      end
    else
      @errors = []
      params.require(:stocks).each do |j|
        stock = Stock.find(j[:stock_id])
        if stock.quantity < j[:quantity]
          @errors.push(stock_id: [:stock_id],
                       msg: 'Produto com pedido maior que o disponivel no estoque')
        end
      end
      json_response(@errors, :conflict)
    end
  end

  def show_all
    @orders = current_user.orders.order(created_at: :desc)
    json_response(@orders)
  end

  def show
    @order = Order.find(params.require(:id))
    json_response(@order)
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
    frete = Correios::Frete::Calculador.new cep_origem: '60711055',
                                            cep_destino: frete_params[:cep_destino],
                                            encomenda: @pacote
    servicos = frete.calcular :sedex, :pac
    json_response(servicos)
  end

  private

  def order_params
    params.permit(
      :frete_value,
      :address_id,
      :value,
      :frete_days,
      :frete_type,
      :payment_type
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
end
