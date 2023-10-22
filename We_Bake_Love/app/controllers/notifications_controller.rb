class NotificationsController < ApplicationController
    def index
      @notifications = Notification.all.where(read: false)
      if @notifications 
        render json: { notifications: @notifications }, status: :ok
      else
        render json: @notifications.errors, status: :unprocessable_entity
      end
    end
    
    def notification_read
        Notification.all.where(read: false).find_by(id: params[:id]).update(read: 1)
        render json: {}, status: :ok
    end
  end
  