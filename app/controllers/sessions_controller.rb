class SessionsController < ApplicationController

  def create
    dj = Dj.find_by(email: params[:email])
    if dj && dj.authenticate(params[:password])
      jwt = JWT.encode(
        {
          dj_id: dj.id, # the data to encode
          exp: 24.hours.from_now.to_i # the expiration time
        },
        ENV['SECRET_KEY_BASE'], # the secret key from the environment
        "HS256" # the encryption algorithm
      )
      render json: { jwt: jwt, email: dj.email, dj_id: dj.id }, status: :created
    else
      render json: {}, status: :unauthorized
    end
  end

end
