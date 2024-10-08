class ApplicationController < ActionController::API

  def current_dj
    auth_headers = request.headers["Authorization"]
    if auth_headers.present? && auth_headers[/(?<=\A(Bearer ))\S+\z/]
      token = auth_headers[/(?<=\A(Bearer ))\S+\z/]
      begin
        decoded_token = JWT.decode(
          token,
          ENV['SECRET_KEY_BASE'], # Use the environment variable instead
          true,
          { algorithm: "HS256" }
        )
        Dj.find_by(id: decoded_token[0]["dj_id"])
      rescue JWT::ExpiredSignature
        nil
      end
    end
  end

  def authenticate_dj
    puts "Authorization Header: #{request.headers['Authorization']}"
    unless current_dj
      render json: {}, status: :unauthorized
    end
  end

end
