class UserDetailMailer < ApplicationMailer
  before_action :set_params

  def accept_mail
    @user = params[:user]
    mail(to: @user.email, subject: "We Have Accepted Your Order, we will let you know if it's completed")
  end

  def cancel_mail
    mail(to: @user.email, subject: "Sorry, Your Order Got Cancled")
  end
  
  def set_params
    @user = params[:user]
    @user_detail = params[:user_detail]
  end
end
