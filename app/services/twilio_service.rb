# # app/services/twilio_service.rb
# require 'twilio-ruby'

# class TwilioService
#   def self.send_sms(to:, body:)
#     account_sid = ENV['TWILIO_ACCOUNT_SID']
#     auth_token = ENV['TWILIO_AUTH_TOKEN']
#     from_phone_number = ENV['TWILIO_PHONE_NUMBER']

#     begin
#       client = Twilio::REST::Client.new(account_sid, auth_token)
#       message = client.messages.create(
#         from: from_phone_number,
#         to: to,
#         body: body
#       )
#       { success: true, sid: message.sid }
#     rescue Twilio::REST::TwilioError => e
#       { success: false, error: e.message }
#     end
#   end
# end

# app/services/twilio_service.rb
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