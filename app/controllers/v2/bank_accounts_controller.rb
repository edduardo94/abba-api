# frozen_string_literal: true

module V2
  class BankAccountsController < ApplicationController
    def create
      bank_account = @current_user.bank_accounts.create!(bank_params)
      json_response(bank_account)
    end

    def index
      bank_accounts = @current_user.bank_accounts
      json_response(bank_accounts)
    end

    def update
      bank_account = @current_user.bank_accounts.find(params[:id])
      if bank_account.update(bank_params)
        json_response(bank_account)
      else
        raise 'Erro ao salvar sua conta'
      end
    end

    def show
      bank_account = @current_user.bank_accounts.find(params[:id])
      json_response(bank_account)
    end

    private

    def bank_params
      params.permit(
        :bank_name,
        :bank_code,
        :account,
        :operation,
        :agency,
        :name,
        :cpf
      )
    end
  end
end
