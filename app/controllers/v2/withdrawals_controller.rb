# frozen_string_literal: true

module V2
  class WithdrawalsController < ApplicationController
    def create
      withdrawal =
        @current_user.withdrawals.create!(value:
                                          @current_user.commission.value, status: 1,
                                          bank_account_id: params[:bank_id])

      json_response(withdrawal)
    rescue StandardError => e
      json_response(e, :unprocessable_entity)
    end

    def index
      withdrawals = @current_user.withdrawals
      json_response(withdrawals)
    end

    def show
      withdrawal = @current_user.withdrawal.find(id: params[:id])
      json_response(withdrawal)
    end

    private

    def withdrawals_params
      params.permit(:id)
    end
  end
end
