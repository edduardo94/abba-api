module V3
  class AuthController < ApplicationController
    skip_before_action :authorize_request, only: %i[forgot_password authenticate]
    before_action :set_user

    def authenticate
      user = User.find_by(email: params[:email])

      if user != nil
        if user.user_type == 0
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

    def forgot_password
      user = User.find_by(email: user_params[:email])
      if user
        UserMailer.with(user: user).forgot_password_email.deliver_now!
      else
        @response = { message: Message.account_already_exists }
        json_response(@response, :not_found)
      end
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
      params.permit(
        :name,
        :email,
        :password,
        :name,
        :cpf,
        :cellphone,
        :phone,
        :gender,
        :birth_date
      )
    end

    def set_user
      @user = current_user
    end

    def address_params
      params.require(:address).permit(
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