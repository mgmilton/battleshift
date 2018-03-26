class ActivationController < ApplicationController
  def index
    @user = current_user
    @user.activate
    @user.generate_api
  end
end
