class ApplicationController < ActionController::API
  before_action :authenticate_request

  private

  def authenticate_request
    token = request.headers["Authorization"]
    decoded_token = JwtService.decode(token)
    @current_user = User.find(decoded_token[:user_id]) if decoded_token

  rescue
    render json: { errors: "Unauthorized" }, status: :unauthorized
  end
end
