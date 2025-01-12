require_relative "boot"

require "rails/all"
require "./app/middleware/authentication_middleware.rb"

Bundler.require(*Rails.groups)

module SmsSender
  class Application < Rails::Application
    config.load_defaults 8.0
    config.autoload_lib(ignore: %w[assets tasks])
    config.middleware.use AuthenticationMiddleware

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*' # Replace '*' with the specific origins allowed to access your API
        resource '/api/*', # Match API routes
          headers: :any,
          methods: %i[get post put patch delete options head], # Include OPTIONS for preflight
          expose: ['Authorization'] # Expose headers if needed
      end
    end
    
  end
end
