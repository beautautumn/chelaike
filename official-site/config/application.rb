require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module OfficialSite
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.time_zone = "Beijing"

    config.i18n.load_path += Dir[Rails.root.join("config", "locales", "**/*.{rb,yml}").to_s]

    config.i18n.default_locale = :"zh-CN"
    config.i18n.available_locales = [:"zh-CN", :en]

    config.generators do |g|
      g.assets false
      g.helper false
      g.test_framework  :rspec
    end

    # Email config
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.perform_deliveries = true
    config.action_mailer.raise_delivery_errors = false
    config.action_mailer.default charset: "utf-8"

    config.action_mailer.smtp_settings = {
      address:              "smtp.exmail.qq.com",
      port:                 25,
      domain:               ENV.fetch("SERVER_HOST", "localhost"),
      user_name:            "robot@chelaike.com",
      password:             "VvWKUXUNeXWaWfHXj2Q9",
      authentication:       :plain,
      enable_starttls_auto: true
    }

    # Ajax CORS
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins "*"
        resource "/pay/pay", headers: :any, methods: [:post]
      end
    end
  end
end
