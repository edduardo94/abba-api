# frozen_string_literal: true

class Withdrawal < ApplicationRecord
  # ##STATUS###
  # 1 solicitado
  # 2 em andamento
  # 3 concluido
  belongs_to :user
  belongs_to :bank_account
  before_create :validate_withdrawal

  after_update :update_comission

  def validate_withdrawal
    withdrawals = user.withdrawals.where(created_at:
      Time.now.beginning_of_month..Time.now.end_of_month)
    raise 'Saque já solicitidado no mes corrente' unless withdrawals.empty?
  end

  def update_comission
    user.commission.update(value: user.commission.value - value) if status == 3
  end
end
