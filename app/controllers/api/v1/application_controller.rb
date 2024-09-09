class Api::V1::ApplicationController < ActionController::API
  before_action :authenticate_request

  private

  def authenticate_request
    token = request.headers["Authorization"]&.split(" ")&.last
    decoded_token = JwtService.decode(token)
    @current_user = User.find(decoded_token[:user_id]) if decoded_token
    if @current_user.nil?
      render json: { success: false, errors: "Unauthorized" }, status: :unauthorized
    end
  rescue
    render json: { success: false, errors: "Unauthorized" }, status: :unauthorized
  end
end
