class ApplicationController < ActionController::API

  # skip_before_action :verify_authenticity_token

  # cart
  include ApplicationHelper

  # user
  helper_method :current_user


  def encode_token(payload)
    JWT.encode(payload, 'yoursecret')
  end
  
  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def require_login
    unless logged_in?
      flash[:error] = "You must be logged in to access this section"
      redirect_to root_path
    end
  end

  def logged_in?
    !current_user.nil?
  end
end
