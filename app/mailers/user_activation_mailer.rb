include Rails.application.routes.url_helpers

class UserActivationMailer < ApplicationMailer
  default from: 'boss@battleshift.com'

  def activation_email(user)
    @user = user
    mail(to: @user.email, subject: "Welcome to Battleshift")
  end
end
