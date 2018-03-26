class RegisterController < ApplicationController
  def new
  end

  def create
    user = User.new(register_params)
    if user.save
      user.generate_api
      user.send_activation
      session[:user_id] = user.id
      flash[:notice] = "User was successfully created"
      redirect_to "/dashboard"
    else
      flash[:error] = "Something went wrong. Please try again."
      render :new
    end
  end

  private
    def register_params
      params.require("/register").permit(:email, :name, :password, :password_confirmation)
    end
end
