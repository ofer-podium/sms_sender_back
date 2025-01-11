class AuthenticationMiddleware
    def initialize(app)
      @app = app
    end
  
    def call(env)
      request = Rack::Request.new(env)
      auth_header = request.get_header('HTTP_AUTHORIZATION')
  
      if auth_header.present? && auth_header.start_with?('Bearer ')
        token = auth_header.split(' ').last
        user_id = verify_token(token)
        env['user_id'] = user_id if user_id
      end
  
      @app.call(env)
    end
  
    private
  
    def verify_token(token)
      decoded_token = JsonWebToken.decode(token)
      decoded_token['user_id'] if decoded_token.present?
    rescue StandardError => e
      Rails.logger.warn("Invalid token: #{e.message}")
      nil
    end
  end