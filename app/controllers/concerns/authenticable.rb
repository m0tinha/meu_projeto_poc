module Authenticable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_request!
  end

  private

  def authenticate_request!
    token = cookies.signed[:access_token] || request.headers['Authorization']&.split(' ')&.last
    public_key = OpenSSL::PKey::RSA.new(File.read(Rails.root.join("config/keys/rsa_public.pem")))
    
    decoded = JWT.decode(token, public_key, true, algorithm: 'RS256')[0]
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
