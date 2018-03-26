class ActivationController < ApplicationController
  def index
    @user = current_user
    @url = "https://battleshift.herokuapp.com/activate"
    @user.activate!
  end
end
