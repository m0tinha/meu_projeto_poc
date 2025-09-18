module Authorizable
  extend ActiveSupport::Concern

  class AuthorizationError < StandardError; end

  included do
    rescue_from AuthorizationError, with: :user_not_authorized
  end

  private

  def authorize_role!(required_role)
    raise AuthorizationError unless current_user&.role == required_role
  end

  def user_not_authorized
    render json: { error: "Usuário não autorizado" }, status: :forbidden
  end
end
