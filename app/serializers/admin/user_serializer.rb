# frozen_string_literal: true

class Admin::UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email,
             :cpf, :gender, :birth_date, :cellphone, :phone,
             :user_type, :activation_status
             
  has_many :addresses
  belongs_to :level
  has_many :withdrawals

  has_one :point
  has_one :wallet
  has_one :commission

  def activation_status
    if defined? object.object
      return object.object.activated?
    else
      return object.activated?
    end
  end
end
