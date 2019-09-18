# frozen_string_literal: true

class AddressSerializer < ActiveModel::Serializer
  attributes :id, :cep, :address, :number, :neighborhood, :city, :complement,
             :state, :is_principal, :user_id
  belongs_to :user
end
