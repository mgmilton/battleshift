class ActivationController < ApplicationController
  def index
    @user = current_user
    @user.activated!
  end
end
