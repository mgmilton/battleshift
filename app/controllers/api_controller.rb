class ApiController < ActionController::API
  before_action :authenticate

  private

  def authenticate
    api_key = request.headers['X-API-Key']
    @current_user = User.find_by(api_key: api_key) if api_key

    unless @current_user
      render status: :unauthorized
      return false
    end
  end
end
