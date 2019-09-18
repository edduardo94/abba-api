# frozen_string_literal: true

class PaghiperNotificationsController < ApplicationController
  skip_before_action :authorize_request, only: :create

  def create
    params['token'] = ENV['PAG_HIPER_TOKEN']
    params['apiKey'] = ENV['PAGHIPER_API_KEY']
    transaction = Paghiper::Transaction.notification(params)
    update_transaction(transaction) if transaction
  end

  private

  def update_transaction(params)
    transaction =
      PaghiperTransaction.find_by(transaction_id: params[:transaction_id])
    transaction.update!(status: params[:status])
    order = Order.find(transaction.order_id)

    order.update!(status: 5) if params[:status] == 'paid'
    order.update!(status: 9) if params[:status] == 'pending'
    order.update!(status: 2)  if params[:status] == 'canceled'
    order.update!(status: 10) if params[:status] == 'refunded'
  end
end
