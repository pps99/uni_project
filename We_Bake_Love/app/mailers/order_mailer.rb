class OrderMailer < ApplicationMailer
    before_action :set_params
  
    def accept_mail
      mail(to: @user.email, subject: "We Have Accepted Your Order, we will let you know if it's completed")
    end
  
    def cancel_mail
      mail(to: @user.email, subject: "Sorry, Your Order Got Cancled")
    end
    
    def set_params
      @user = params[:user]
      @order = params[:order]
      @order_details = params[:order_details]
      @sub_total = @order_details.sum { |order_detail| order_detail['price'] }
      @tax = 0.05*@sub_total
      @description = params[:description]
    end
  end
  