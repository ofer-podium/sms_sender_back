module Api
  class MessagesController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:send_message, :user_messages]
     
    # Fetch messages sent by a specific user
     def user_messages
      user_id = request.env['user_id']
      unless user_id
        render json: { error: "Unauthorized: Missing or invalid token" }, status: :unauthorized
        return
      end

      # Fetch messages from the service
      messages = MessagesService.fetch_user_messages(user_id)

      render json: { messages: messages }, status: :ok
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

      print "SID: #{message_sid}, Status: #{message_status}\n"

      response.status = 204
    end  
  end
end