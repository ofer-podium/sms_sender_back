require_relative "boot"

require "rails/all"
require "./app/middleware/authentication_middleware.rb"

Bundler.require(*Rails.groups)

module SmsSender
  class Application < Rails::Application
    config.load_defaults 8.0
    config.autoload_lib(ignore: %w[assets tasks])
    config.middleware.use AuthenticationMiddleware
  end
end
