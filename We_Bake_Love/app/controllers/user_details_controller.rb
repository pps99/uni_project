require 'json'
class UserDetailsController < ApplicationController

  def new
    @user_detail = UserDetail.new
  end

  def index
    @user_details = UserDetail.where(status: "pending")
    if @user_details.present? 
          @grouped_user_details = @user_details.group_by { |user_detail| user_detail.user_id }
          render json: { grouped_user_details: @grouped_user_details }, status: :ok
    else
          render json: { grouped_user_details: []}, status: :ok
    end

  end

  def show
    @user_details = UserDetailService.getUserDetailsByID(params[:id])
    @user_details = @user_details.where(status: "pending")
    @user_detail = UserDetailService.getUserDetailByID(params[:id])
  end

  def accept    
    @user = User.find(params[:user_id])
    @sql = "SET SQL_SAFE_UPDATES = 0;"
    ActiveRecord::Base.connection.execute(@sql)
    @sql = "update user_details set status='accepted' where user_id =#{@user.id} ;"
    ActiveRecord::Base.connection.execute(@sql)
    @sql = "update users set status='accepted' where id=#{@user.id}"
    ActiveRecord::Base.connection.execute(@sql)
    @sql_safe_mode = "SET SQL_SAFE_UPDATES = 1;"
    ActiveRecord::Base.connection.execute(@sql_safe_mode)
    UserDetailMailer.with(user: @user).accept_mail.deliver_now
    render json: {}, status: :ok
  end
  def cancel
    @user = User.find(params[:user_id])
    @sql = "SET SQL_SAFE_UPDATES = 0;"
    ActiveRecord::Base.connection.execute(@sql)
    @sql = "update user_details set status='cancelled' where user_id =#{@user.id}  ;"
    ActiveRecord::Base.connection.execute(@sql)
    @sql = "update users set status='cancled' where id=#{@user.id}"
    ActiveRecord::Base.connection.execute(@sql)
    @sql_safe_mode = "SET SQL_SAFE_UPDATES = 1;"
    ActiveRecord::Base.connection.execute(@sql_safe_mode)
    UserDetailMailer.with(user: @user).cancel_mail.deliver_now
    render json: {}, status: :ok
  end

  def create
    @cart_items = JSON.parse(request.body.read)
    @user.update(status: 'pending')
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
      name: @user.name,
      phone: @user.phone,
      address: @user.address,
      option: cart_item['option']
    }
  end
end
