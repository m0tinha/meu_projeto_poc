class AuthController < ApplicationController

  def login
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      access_token  = encode_token({ user_id: user.id, exp: 15.minutes.from_now.to_i })
      refresh_token = encode_token({ user_id: user.id, exp: 7.days.from_now.to_i })

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
        user: {
          id: user.id,
          email: user.email
        },
        tokens: {
          access: access_token,
          refresh: refresh_token
        }
      }, status: :ok
    else
      render json: { error: 'Email ou senha inválidos' }, status: :unauthorized
    end
  end

  private

  def encode_token(payload)
    JWT.encode(payload, PRIVATE_KEY, "RS256")
  end
end
