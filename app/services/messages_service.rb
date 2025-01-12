class MessagesService

  def self.fetch_user_messages(user_id, page: 1, per_page: 10)
    offset = (page - 1) * per_page
    Message.where(user_id: user_id)
           .order(created_at: :desc)
           .limit(per_page)
           .offset(offset)
  end

  
  # Trigger sending a message via Twilio
  def self.send_message(to:, content:)
    TwilioService.instance.send_sms(to: to, body: content)
  end

  # Save the message to the database
  def self.save_message(to:, content:, user_id:, sid:)
    message = Message.new(
      recipient_phone: to,
      content: content,
      user_id: user_id,
      sent_at: Time.current,
      status: 'sent',
      sid: sid
    )

    if message.save
      { success: true, message: message }
    else
      { success: false, error: "Failed to save message: #{message.errors.full_messages.join(', ')}" }
    end
  end

  # Fetch all messages for a user
  def self.fetch_user_messages(user_id)
    Message.where(user_id: user_id).order(created_at: :desc)
  end
end