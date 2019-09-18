class UserMailer < ApplicationMailer
  def forgot_password_email
    @user =  params[:user]
    @url  =  ENV['FRONT_URL'] + '/redefinir-senha/?token=' + @user.secure_token

    mail(to: @user.email, subject: 'Redefinição de senha')
  end
end
