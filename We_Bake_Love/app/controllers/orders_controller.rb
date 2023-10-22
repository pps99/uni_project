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

  def completed_order
    @completed_orders_with_details = Order
                                      .joins(:order_details)
                                      .where(status: "accepted")
                                      .where("EXTRACT(MONTH FROM orders.created_at) = ? AND EXTRACT(YEAR FROM orders.created_at) = ?", params[:month], params[:year])
                                      .pluck('order_details.cake_name', 'order_details.quantity', 'order_details.price')
  
    @combined_result = combine_arrays_with_same_name(@completed_orders_with_details)
  
    if @combined_result
      render json: { combined_result: @combined_result }, status: :ok
    else
      render json: { combined_result: []}, status: :ok
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
    notification = Notification.new({ user_id: @user.id, message: "order_request" })
    if notification.save
      notification_json = notification.to_json
      # Broadcast the JSON representation of the notification
      ActionCable.server.broadcast("notifications_1", notification: notification_json)
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

  def combine_arrays_with_same_name(array)
    grouped = array.group_by { |item| item[0] } # Group items by the first element (name)
  
    combined_array = grouped.map do |name, items|
      total_quantity = items.sum { |item| item[1].to_i }
      total_price = items.sum { |item| item[2].to_i }
      [name, total_quantity.to_s, total_price]
    end
  
    combined_array
  end
  
end