class ApiController < ActionController::API
  before_action :authenticate

  private
  def current_user
    api_key = request.headers['X-API-Key']
    @current_user = User.find_by(api_key: api_key) if api_key
  end

  def authenticate
    unless current_user &&  current_user.activated?
      render json: {body: "Unauthorized", message: "Unauthorized"}.to_json, status: :unauthorized
      return false
    end
  end
end
