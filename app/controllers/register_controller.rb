class RegisterController < ApplicationController
  def new
  end

  def create
    user = User.new(register_params)
    if user.save
      user.send_activation
      session[:user_id] = user.id
      redirect_to "/dashboard"
    else
      render :new
    end
  end

  private
    def register_params
      params.require("/register").permit(:email, :name, :password, :password_confirmation)
    end
end
