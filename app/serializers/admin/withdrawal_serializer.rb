# frozen_string_literal: true

class Admin::WithdrawalSerializer < ActiveModel::Serializer
  attributes :id, :value, :status, :created_at

  belongs_to :user
  belongs_to :bank_account
end
