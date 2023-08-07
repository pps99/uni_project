class ApplicationController < ActionController::API

  include Pagy::Backend
  before_action :authorized

  def encode_token(payload)
    JWT.encode(payload, 'yoursecret')
  end

  def auth_header
    request.headers['authorization']
  end
  
  def decode_token
    if auth_header
      token = auth_header.split(' ')[1]
      begin
        JWT.decode(token, 'yoursecret', true, algorithm: 'HS256')
      rescue  JWT::DecodeE
        nil
      end
    end
  end

  def logged_in_user
    if decode_token
      user_id = decode_token[0]['user_id']
      @user = User.find_by(id: user_id)
    end
  end

  def logged_in?
    !!logged_in_user
  end

  def authorized
    render json: { message: 'Please log in' }, status: :unauthorized unless logged_in?
  end
end
