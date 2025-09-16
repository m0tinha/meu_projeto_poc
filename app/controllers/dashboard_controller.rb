class DashboardController < ApplicationController
   before_action :authorize_request

  def index
    render json: { message: "Bem-vindo #{@current_user.email}!" }
  end

  private

  def authorize_request
    token = cookies.signed[:access_token]

    begin
      decoded = JWT.decode(token, PUBLIC_KEY, true, { algorithm: "RS256" })[0]
      @current_user = User.find(decoded["user_id"])
    rescue JWT::ExpiredSignature
      render json: { error: "Token expirado" }, status: :unauthorized
    rescue JWT::DecodeError
      render json: { error: "Token inválido" }, status: :unauthorized
    end
  end
end
