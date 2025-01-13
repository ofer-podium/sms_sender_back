require 'twilio-ruby'

class TwilioService
  include Singleton

  def initialize
    @client = Twilio::REST::Client.new(
      ENV['TWILIO_ACCOUNT_SID'],
      ENV['TWILIO_AUTH_TOKEN']
    )
  end

  def send_sms(to:, body:)
    begin
      message = @client.messages.create(
        from: ENV['TWILIO_PHONE_NUMBER'],
        to: to,
        body: body,
        status_callback: ENV['TWILIO_STATUS_CALLBACK_URL']
      )
      { success: true, sid: message.sid }
    rescue Twilio::REST::TwilioError => e
      { success: false, error: e.message }
    end
  end
end