class UserActivationMailer < ApplicationMailer

  def activation_email(user)
    @user = user
    mail(to: @user.email, subject: "Welcome to Battleshift")
  end
end
