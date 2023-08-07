require 'json'
class UserDetailsController < ApplicationController

  def new
    @user_detail = UserDetail.new
  end

  def index
    @user_details = UserDetail.where(status: "pending")
    @user_orderaccepteddetails = UserDetail.where(status: "accepted")
    @user_ordercancelleddetails = UserDetail.where(status: "cancelled")
  end

  def show
    @user_details = UserDetailService.getUserDetailsByID(params[:id])
    @user_details = @user_details.where(status: "pending")
    @user_detail = UserDetailService.getUserDetailByID(params[:id])
  end

  def accept
    @user_detail = UserDetail.find(params[:format])
    @sql = "SET SQL_SAFE_UPDATES = 0;"
    ActiveRecord::Base.connection.execute(@sql)
    @sql = "update user_details set status='accepted' where user_id =#{@user_detail.user.id} ;"
    ActiveRecord::Base.connection.execute(@sql)
    @sql_safe_mode = "SET SQL_SAFE_UPDATES = 1;"
    ActiveRecord::Base.connection.execute(@sql_safe_mode)
    UserDetailMailer.with(user: @user_detail.user, user_detail: @user_detail).accept_mail.deliver_now
    Rails.logger.debug(current_user)
    redirect_to user_details_path
  end
  def cancel
    @user_detail = UserDetail.find(params[:format])
    @sql = "SET SQL_SAFE_UPDATES = 0;"
    ActiveRecord::Base.connection.execute(@sql)
    @sql = "update user_details set status='cancelled' where user_id =#{@user_detail.user.id} ;"
    ActiveRecord::Base.connection.execute(@sql)
    @sql_safe_mode = "SET SQL_SAFE_UPDATES = 1;"
    ActiveRecord::Base.connection.execute(@sql_safe_mode)
    UserDetailMailer.with(user: @user_detail.user, user_detail: @user_detail).cancel_mail.deliver_now
    redirect_to user_details_path
  end

  def create
    @cart_items = JSON.parse(request.body.read)

    @cart_items.each do |cart_item|
      @user_detail = UserDetail.new(user_detail_params(cart_item))
      UserDetailService.createUserDetail(@user_detail)
    end
    if @user_detail
      render json: { user_detail: @user_detail }, status: :created
    else
      render json: @user_detail.errors, status: :unprocessable_entity
    end
  end

  def edit
    @user_detail = UserDetailService.getUserDetailByID(params[:id])
  end

  private

  def user_detail_params(cart_item)
    {
      cake_name: cart_item['cake_name'],
      quantity: cart_item['quantity'],
      price: cart_item['unit_price'],
      total: (cart_item['quantity'] * cart_item['unit_price']),
      user_id: @user.id,
      phone: '09780662858',
      address: '21st street'
    }
  end
end
