# frozen_string_literal: true

class User < ApplicationRecord
  ##### **USER TYPE** #####
  # 0 - ADMIN
  # 1 - consumidor
  # 2 - revendedor
  # 3 - representante
  # 4 - socio
  # encrypt password
  has_secure_password

  # Validations
  validates_presence_of :name, :email, :password_digest

  has_many :addresses
  has_many :orders

  has_one :point
  has_one :wallet
  has_one :commission
  has_many :withdrawals
  has_many :activations
  has_many :bank_accounts
  belongs_to :host, class_name: "User", foreign_key: "host_user_id", required: false
  belongs_to :level, inverse_of: :users, required: false

  after_create :create_wallet

  def secure_token
    JsonWebToken.encode(user_id: id)
  end

  def create_wallet
    Point.create!(value: 0, networking_points: 0, user_id: id)
    Wallet.create(value: 0, user_id: id)
    Commission.create(value: 0, user_id: id)
  end

  def activated?
    @orders = orders.this_month
    @orders&.each do |order|
      return true if [3, 4, 5, 6, 7, 8].include?(order.status)
    end
    false
  end

  def first_activated?
    orders.each do |order|
      return true if [3, 4, 5, 6, 7, 8].include?(order.status)
    end
    false
  end
end
