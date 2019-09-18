# frozen_string_literal: true

class WithdrawalSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :value, :bank, :status

  def bank
    a = BankAccount.find(object.bank_account_id)
    if !a
      return false
    else
      return a
    end
  end

  def status
    case object.status
    when 1
      'Solicitado'
    when 2
      'Em andamento'
    when 3
      'Concluido'
    end
  end
end
