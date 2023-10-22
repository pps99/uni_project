class TransitionsController < ApplicationController

  def index
    @transitions = Transition.includes(:user).where('transition_no', '!=', nil)
    @transitions_array = []
    @transitions.each do |transition|
      @transitions_array.push({
        transition: transition,
        user_detail: transition.user
      })
    end
    render json: { recharge_items: @transitions_array }, status: :ok
  end
  
  def getAmount
    @amount = TransitionService.getAmount(params[:user_id])
    render json: { amount: @amount }, status: :ok
  end

  def updateAccountAmount
    TransitionService.updateAccountAmount(params[:transition_id])
    render json: {}, status: :ok
  end

  def cancelAccountAmount
    TransitionService.cancelAccountAmount(params[:transition_id])
    render json: {}, status: :ok
  end

  def savetransition_no
    @transition_no = TransitionService.savetransition_no(params)
    notification = Notification.new({ user_id: params[:user_id], message: "recharge_amount" })

    if notification.save
      notification_json = notification.to_json
      # Broadcast the JSON representation of the notification
      ActionCable.server.broadcast("notifications_1", notification: notification_json)
      render json: {}, status: :ok
    else
      # Handle the case where the notification couldn't be saved
      render json: { error: 'Failed to save notification' }, status: :unprocessable_entity
    end
  end
end
