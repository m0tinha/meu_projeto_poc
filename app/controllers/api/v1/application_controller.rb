class Api::V1::ApplicationController < ActionController::API
  include Authenticable
  include Authorizable
  include ActionController::Cookies
  private

  def current_user
    @current_user
  end
end
