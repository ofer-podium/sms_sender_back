class MessagesChannel < ApplicationCable::Channel
  def subscribed
    # Subscribe to a specific stream
    stream_from "messages_#{params[:channel]}"
  end

  def unsubscribed
    # Cleanup when the channel is unsubscribed
  end
end