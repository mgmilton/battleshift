class ActivationController < ApplicationController
  def index
    @user = current_user
    @user.activate!
  end
end
