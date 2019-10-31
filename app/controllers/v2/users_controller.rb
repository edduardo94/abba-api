# frozen_string_literal: true

module V2
  class UsersController < ApplicationController
    skip_before_action :authorize_request, only: %i[forgot_password authenticate create]
    before_action :set_user

    def authenticate
      user = User.find_by(email: params[:email])
      if !user.nil?
        if user.user_type == 2 || user.user_type == 3 || user.user_type == 4
          auth_token =
            AuthenticateUser.new(auth_params[:email], auth_params[:password]).call
          json_response(auth_token: auth_token)
        else
          raise(ExceptionHandler::AuthenticationError, Message.invalid_credentials)
        end
      else
        raise(ExceptionHandler::AuthenticationError, Message.invalid_credentials)
      end
    end

    def create
      if !User.exists?(email: user_params[:email])
        ActiveRecord::Base.transaction do
          user = User.create!(user_params.except(:address))
          add_address(user.id, address_params, true)
          auth_token = AuthenticateUser.new(user.email, user.password).call
          @response = { message: Message.account_created, auth_token: auth_token }
          @status = :created
        end
      else
        @response = { message: Message.account_already_exists }
        @status = :conflict
      end
      json_response(@response, @status)
    end

    def myself
      json_response(@user)
    end

    def update
      @user.update(user_params)
      if @user.addresses.where(is_principal: true).first
        @user.addresses.where(is_principal: true).first.update(principal_address_params)
      else
        add_address(@user.id, address_params, true)
      end
      json_response(@user)
    end

    def update_password
      @user.update(password: params.require(:password))
    end

    def forgot_password
      user = User.find_by(email: user_params[:email])
      if user
        UserMailer.with(user: user).forgot_password_email.deliver_now!
      else
        @response = { message: Message.invalid_credentials }
        json_response(@response, :not_found)
      end
    end

    def load_hosted_users
      users = User.where(host_user_id: current_user.id)
      json_response(users)
    end

    def load_hosted_private_users      
      users = User.where(host_user_id: params.require(:id))
      json_response(users)
    end

    def create_address
      address = add_address(@user.id, address_params_alone)
      json_response(address)
    end

    def update_address
      @user.addresses.find(address_params_alone[:id]).update(address_params_alone)
      json_response(@user)
    end

    def destroy_address
      @user.addresses.find(address_params_alone[:id]).destroy
      json_response(@user)
    end

    private

    def add_address(user_id, params, is_principal = false)
      params[:user_id] = user_id
      params[:is_principal] = is_principal
      Address.create!(params)
    end

    def auth_params
      params.permit(:email, :password)
    end

    def user_params
      params.require(:user).permit(
        :name,
        :email,
        :password,
        :name,
        :cpf,
        :cellphone,
        :phone,
        :gender,
        :birth_date,
        :user_type,
        :host_user_id
      )
    end

    def set_user
      @user = current_user
    end

    def address_params
      params.require(:user).require(:address).permit(
        :id,
        :cep,
        :address,
        :number,
        :complement,
        :neighborhood,
        :city,
        :state
      )
    end

    def principal_address_params
      params.require(:address).permit(
        :cep,
        :address,
        :number,
        :complement,
        :neighborhood,
        :city,
        :state
      )
    end

    def address_params_alone
      params.permit(
        :id,
        :cep,
        :address,
        :number,
        :complement,
        :neighborhood,
        :city,
        :state
      )
    end
  end
end
