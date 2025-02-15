require 'pubnub'

class PubNubService
  include Singleton

  def initialize
    @pubnub = Pubnub.new(
      subscribe_key: ENV['PUBNUB_SUBSCRIBE_KEY'],
      publish_key: ENV['PUBNUB_PUBLISH_KEY'],
      uuid: 'server'
    )
  end

  def publish(channel:, message:)
    result = @pubnub.publish(
      channel: channel,
      message: message
    ).value
  
    if result.status[:code] == 200
      Rails.logger.info "Message successfully sent to channel #{channel}"
      { success: true }
    else
      Rails.logger.error "Failed to send message to channel #{channel}: #{result.status[:error_message]}"
      { success: false, error: result.status[:error_message] }
    end
  rescue StandardError => e
    Rails.logger.error "PubNub publish failed: #{e.message}"
    { success: false, error: e.message }
  end
end