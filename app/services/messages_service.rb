class MessagesService

  def self.fetch_user_messages(user_id, page, per_page)
    offset = (page.to_i - 1) * per_page.to_i
    per_page = per_page.to_i
    messages = Message.where(user_id: user_id)
                      .order(created_at: :desc)
                      .limit(per_page)
                      .offset(offset)
  
    total = Message.where(user_id: user_id).count
  
    { messages: messages, total: total }
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

    # Update the status of a message
    def self.update_message_status(sid:, status:)
      message = Message.find_by(sid: sid)
  
      if message
        message.update(status: status)
        { success: true, message: message }
      else
        { success: false, error: "Message with SID #{sid} not found" }
      end
    end
end