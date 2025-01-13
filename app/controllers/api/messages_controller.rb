module Api
  class MessagesController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:send_message, :user_messages, :message_status]
     
    # Fetch messages sent by a specific user
     def user_messages
      user_id = request.env['user_id']
      unless user_id
        render json: { error: "Unauthorized: Missing or invalid token" }, status: :unauthorized
        return
      end

      limit = params[:limit] || 10
      page = params[:page] || 1
      dbResponse = MessagesService.fetch_user_messages(user_id, page, limit)
      render json: { messages: dbResponse[:messages], total: dbResponse[:total] }, status: :ok
    end
    
    # Send a message
    def send_message
      # Validate input
      validation_result = MessageInputValidator.validate(params.permit(:recipient_phone, :content))
      unless validation_result[:success]
        render json: { errors: validation_result[:errors] }, status: :unprocessable_entity
        return
      end

      # Get user_id from the request environment
      user_id = request.env['user_id']
      unless user_id
        render json: { error: "Unauthorized: Missing or invalid token" }, status: :unauthorized
        return
      end

      # Trigger sending the message via Twilio
      twilio_result = MessagesService.send_message(to: params[:recipient_phone], content: params[:content])
      unless twilio_result[:success]
        render json: { error: twilio_result[:error] }, status: :unprocessable_entity
        return
      end

      # Save the message to the database
      save_result = MessagesService.save_message(
        to: params[:recipient_phone],
        content: params[:content],
        user_id: user_id,
        sid: twilio_result[:sid]
      )

      if save_result[:success]
        render json: { message: "Message sent successfully", sid: twilio_result[:sid] }, status: :ok
      else
        render json: { error: save_result[:error] }, status: :unprocessable_entity
      end
    end

    def message_status
      message_sid = params['MessageSid']
      message_status = params['MessageStatus']
    
      Rails.logger.info "Received Twilio event - SID: #{message_sid}, Status: #{message_status}"
    
      # Update the message status in the database
      result = MessagesService.update_message_status(sid: message_sid, status: message_status)
    
      if result[:success]
        Rails.logger.info "Updated message SID #{message_sid} to status #{message_status}"

        # Fetch the associated user and send a notification to their PubNub channel
        user = result[:message]&.user
        if user&.channel
          pubnub_service = PubNubService.instance
          pubnub_result = pubnub_service.publish(
            channel: user.channel,
            message: {
              id: result[:message].id,
              content: result[:message].content,
              recipient_phone: result[:message].recipient_phone,
              sent_at: result[:message].sent_at,
              status: message_status,
              sid: message_sid,
            }
          )
    
          if pubnub_result[:success]
            Rails.logger.info "Notification sent to channel #{user.channel} for user ID #{user.id}"
          else
            Rails.logger.error "Failed to send notification to channel #{user.channel}: #{pubnub_result[:error]}"
          end
        else
          Rails.logger.warn "User or channel not found for message SID #{message_sid}"
        end
    
        head :no_content # Return 204 No Content as the response
      else
        Rails.logger.error "Failed to update message status: #{result[:error]}"
        render json: { error: result[:error] }, status: :unprocessable_entity
      end
    end
  end
end