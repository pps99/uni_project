class OrdersController < ApplicationController

  def index
    @pending_orders_with_details = Order.includes(:order_details).where(status: "pending")
    @orders = []
    @pending_orders_with_details.each do |order|
      @orders.push({
        order: order,
        order_details: order.order_details
      })
    end
    if @pending_orders_with_details
      render json: { pending_orders_with_details: @orders }, status: :ok
    else
      render json: { pending_orders_with_details: []}, status: :ok
    end
  end

  def create
    data = JSON.parse(request.body.read)
    @user.update(status: 'pending')
    @order = Order.new(order_params(data))
    @order.save
    @cart_items = data['cart_items']
    @cart_items.each do |cart_item|
      @order_detail = OrderDetail.new(order_detail_params(cart_item,@order.id))
      OrderDetailService.createOrderDetail(@order_detail)
    end
    if @order 
      render json: { order: @order }, status: :created
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end
  
  def accept
    @order = Order.find(params[:order_id])
    @order.update(status: 'accepted')
    @user = User.find(@order.user_id)
    @user.update(status: 'accepted')
    TransitionService.updateAmount(@order)
    OrderMailer.with(user: @user, order: @order, order_details: @order.order_details, description: '').accept_mail.deliver_now
    render json: {}, status: :ok
  end

  def cancel
    @order = Order.find(params[:order_id])
    @order.update(status: 'canceled')
    @user = User.find(@order.user_id)
    @user.update(status: 'canceled')
    OrderMailer.with(user: @user, order: @order, order_details: @order.order_details, description: params[:description]).cancel_mail.deliver_now
    render json: {}, status: :ok
  end


  private

  def order_params(data)
    {
      user_id: @user.id,
      name: @user.name,
      phone: @user.phone,
      address: @user.address,
      total: data['total_price'],
      option: data['selectedOption']
    }
  end
  def order_detail_params(cart_item,order_id)
    {
      order_id: order_id,
      cake_name: cart_item['cake_name'],
      quantity: cart_item['quantity'],
      price: cart_item['quantity']*cart_item['unit_price']
    }
  end
end