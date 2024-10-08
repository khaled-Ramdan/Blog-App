module Api
  module V1
    class AuthenticationController < ApplicationController
      include Rails.application.routes.url_helpers
      skip_before_action :authenticate_request, only: [ :login, :signup ]
      def signup
        user = User.new(user_params)
        if user.valid?
          token = JwtService.encode(user_id: user.id)
          if user.save
            render json: { success: true, user: UserRepresenter.new(user, user.image.attached? ? url_for(user.image) : nil).as_json, token: token }, status: :created
          else
            render json: { success: false, errors: user.errors.full_messages }, status: :unprocessable_entity
          end
        else
          render json: { success: false, errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def login
        user = User.find_by(email: params[:email])
        if user&.authenticate(params[:password])
          token = JwtService.encode(user_id: user.id)
          render json: { success: true, user: UserRepresenter.new(user, user.image.attached? ? url_for(user.image) : nil).as_json, token: token }, status: :ok
        else
          render json: { success: false, errors: "Invalid Email Or Password" }, status: :unauthorized
        end
      end

      private

      def user_params
        params.permit(:name, :email, :password, :image)
      end
    end
  end
end
