# app/channels/notifications_channel.rb
class NotificationsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "notifications_1"
  end

  def unsubscribed
    # Any cleanup needed when the channel is unsubscribed
  end
end
