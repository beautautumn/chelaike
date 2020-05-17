require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
require "rails/test_unit/railtie"

Bundler.require(*Rails.groups)

module MegatronApi
  class Application < Rails::Application
    config.autoload_paths << Rails.root.join("lib")
  end
end
