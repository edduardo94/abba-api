# frozen_string_literal: true

require 'pagarme'
class PagarmeNotificationsController < ApplicationController
  skip_before_action :authorize_request, only: :create

  def create
    puts request
    # if valid_postback?
    # Handle your code here
    # postback payload is in params
    update_transaction(params)
    # else
    # render_invalid_postback_response
    # end
  end

  private

  def valid_postback?
    raw_post  = request.raw_post
    signature = request.headers['HTTP_X_HUB_SIGNATURE']
    PagarMe::Postback.valid_request_signature?(raw_post, signature)
  end

  def render_invalid_postback_response
    render json: { error: 'invalid postback' }, status: 400
  end

  def update_transaction(params)
    transaction = PagarMeTransaction.find_by(pagarme_id: params[:transaction][:id])
    order = Order.find(transaction.order_id)
    if params[:current_status] == 'paid' || params[:current_status] == 'authorized'
      order.update!(status: 5)
    end
    if params[:current_status] == 'pending' || params[:current_status] == 'waiting_payment'
      order.update!(status: 9)
    end
    if params[:current_status] == 'refused' || params[:current_status] == 'failed' || params[:current_status] == 'refunded'
      order.update!(status: 2)
    end
  end
end
