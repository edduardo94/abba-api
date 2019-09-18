# frozen_string_literal: true

class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email,
             :cpf, :gender, :birth_date, :cellphone, :phone,
             :user_type, :activation_status, :direct_hosted_users_count, 
             :first_activated

  has_many :addresses

  has_one :point
  has_one :wallet
  has_one :commission
  belongs_to :level

  def activation_status
    object.activated?
  end

  def first_activated
    object.first_activated?
  end
  

  def direct_hosted_users_count
    users = User.where(host_user_id: object.id)
    users.count
  end
end
