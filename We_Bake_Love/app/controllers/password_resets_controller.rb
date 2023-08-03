class PasswordResetsController < ApplicationController
  def new
  end

  def create
    binding.pry
    @user = User.find_by(email:params[:email])

    if @user.present?
      PasswordMailer.with(user: @user).reset.deliver_now
      render json: { message: 'We have sent a link to reset yout password' }, status: :ok
    else
      render json: { error: {error_res: "Sorry, Cannot find a user with that email"} }, status: :unprocessable_entity
    end
  end
  
  def edit
    @user = User.find_signed!(params[:token],purpose: "password_reset")
    rescue ActiveSupport::MessageVerifier::InvalidSignature
    redirect_to root_path,alert: "Yout token has expired"
  end

  def update
    binding.pry
    @user = User.find_signed(params[:token],purpose: "password_reset")
    return render json: { error: {error_res: 'Token Has Expired', password_confirmation: '' } }, status: :unprocessable_entity unless @user.present?
    if @user.update(password_params)
      render json: { message: 'User has successfully Updated Password' }, status: :ok
    else
      binding.pry
      render json: { error: {error_res: 'Token Has Expired', password_confirmation: @user.errors } }, status: :unprocessable_entity
    end
  end
  
  private
  def password_params
    params.permit(:password, :password_confirmation)
  end
end
