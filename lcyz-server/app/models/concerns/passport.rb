module Passport
  extend ActiveSupport::Concern

  Info = Struct.new(:device_number, :mobile_app_version, :platform, :app_key)

  included do
    attr_writer :passport

    def passport
      @passport || {}
    end
  end
end
