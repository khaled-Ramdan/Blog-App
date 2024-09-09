require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

module RailsPostgres
  class Application < Rails::Application
    config.load_defaults 7.2
    config.autoload_lib(ignore: %w[assets tasks])
    config.api_only = true

    # Ensure sessions are enabled for Sidekiq::Web
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore, key: "Blog-App"
  end
end
