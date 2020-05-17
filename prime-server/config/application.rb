require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'silencer/logger'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Prime
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = "Beijing"

    config.i18n.load_path += Dir[Rails.root.join("config", "locales", "**/*.{rb,yml}").to_s]
    config.eager_load_paths << Rails.root.join("lib", "plugins")

    config.i18n.default_locale = :"zh-CN"
    config.i18n.available_locales = [:"zh-CN", :en]

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    config.generators do |g|
      g.assets false
      g.helper false
      g.test_framework  :rspec
    end

    config.middleware.insert_before 0, "Rack::Cors", debug: Rails.env.development?, logger: (-> { Rails.logger }) do
      allow do
        origins "*"

        resource "/api/*",
          headers: :any,
          methods: [:get, :post, :options, :delete, :put, :patch],
          expose: [:"X-Total", :"X-Per-Page", :"X-Powered-By"]
      end
    end

    # /test , /api/util/test 的请求不计入日志
    config.middleware.swap Rails::Rack::Logger, Silencer::Logger,
      :silence => ["/test"]

    config.middleware.insert_after Rack::Cors, Rack::UTF8Validator

    config.middleware.use Rack::JSONP

    Spreadsheet.client_encoding = "UTF-8"

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
  end
end
