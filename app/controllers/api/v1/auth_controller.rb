class Api::V1::AuthController < Api::V1::ApplicationController
  skip_before_action :authenticate_request!, only: [:login, :register]

  def login
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      private_key = OpenSSL::PKey::RSA.new(File.read(Rails.root.join("config/keys/rsa_private.pem")))
      access_token = JWT.encode({ user_id: user.id, role: user.role, exp: 15.minutes.from_now.to_i }, private_key, "RS256")
      refresh_token = JWT.encode({ user_id: user.id, exp: 7.days.from_now.to_i }, private_key, "RS256")

      cookies.signed[:access_token] = {
        value: access_token,
        httponly: true,
        secure: Rails.env.production?,
        same_site: :strict
      }

      cookies.signed[:refresh_token] = {
        value: refresh_token,
        httponly: true,
        secure: Rails.env.production?,
        same_site: :strict
      }

      render json: {
        message: "Login realizado com sucesso",
        user: { id: user.id, email: user.email, role: user.role },
        tokens: { access: access_token, refresh: refresh_token }
      }, status: :ok
    else
      render json: { error: 'Email ou senha inválidos' }, status: :unauthorized
    end
  end

  def register
    user = User.new(user_params)
    if user.save
      render json: { message: 'Usuário criado com sucesso', user: { id: user.id, email: user.email, role: user.role } }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(:name, :email, :password, :role)
  end
end
