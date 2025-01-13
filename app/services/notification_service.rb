class NotificationService
    def self.send_to_channel(channel, message)
      ActionCable.server.broadcast("messages_#{channel}", { message: message })
    end
  end