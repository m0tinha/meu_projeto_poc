class Api::V1::DashboardController < Api::V1::ApplicationController
  before_action :authorize_request

  rescue_from AuthorizationError, with: :user_not_authorized

  def index
    render json: { message: "Bem-vindo #{current_user.email}!", role: current_user.role }
  end

  def admin_panel
    authorize_role!('admin')
    render json: { message: "Painel admin acessado com sucesso!" }
  end

  private

  def authorize_request
    token = cookies.signed[:access_token]
    public_key = OpenSSL::PKey::RSA.new(File.read(Rails.root.join("config/keys/rsa_public.pem")))
    decoded = JWT.decode(token, public_key, true, algorithm: "RS256")[0]
    @current_user = User.find(decoded["user_id"])
  rescue JWT::ExpiredSignature
    render json: { error: "Token expirado" }, status: :unauthorized and return
  rescue JWT::DecodeError
    render json: { error: "Token inválido" }, status: :unauthorized and return
  end

  def current_user
    @current_user
  end
end
