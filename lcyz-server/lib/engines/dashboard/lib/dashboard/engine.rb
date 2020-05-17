module Dashboard
  class Engine < ::Rails::Engine
    require "jquery-rails"
    require "sass-rails"
    require "ipa_reader"
    require "zip/zip"
#    require "carrierwave"
#    require "rest-client"
#    require "carrierwave-aliyun"
    isolate_namespace Dashboard
  end
end
