class SessionsController < ApplicationController
  def new

  end

  def create
    user = User.find_by(email: user_params[:email])
    if user && user.authenticate(user_params[:password])
      session[:user_id] = user.id
      redirect_to dashboard_path
    else
      render :new
    end
  end

  def destroy
    session.destroy
    flash[:success] = "Successfully Logged Out"
    redirect_to root_path
  end

  private

    def user_params
      params.permit(:email, :password)
    end

end
