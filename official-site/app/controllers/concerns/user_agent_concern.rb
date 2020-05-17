# frozen_string_literal: true
module UserAgentConcern
  extend ActiveSupport::Concern

  included do
    # Example: change_view_by_device :only => [:index]
    def self.change_view_by_device(*before_filter_args)
      before_action(DeviceDetectHelper, *before_filter_args)
      layout(proc { |controller| controller.device_detect_helper.layout })
    end
  end

  def device_detect_helper
    @device_detect_helper ||= DeviceDetectHelper.new(self)
  end

  class DeviceDetectHelper
    def self.before(controller)
      new(controller).tap do |helper|
        controller.instance_variable_set(:@device_detect_helper, helper)
      end.detect
    end

    attr_reader :controller, :client, :layout

    def initialize(controller)
      @controller = controller
      @layout = nil
    end

    def detect
      @client = DeviceDetector.new(@controller.request.user_agent)
      case client.device_type
      when "smartphone", "tablet"
        @wechat = true if client.name == "WeChat"
        @layout = "mobile"
        @controller.prepend_view_path "app/views/mobile"
      when "desktop"
        @layout = "desktop"
        @controller.prepend_view_path "app/views/desktop"
      else
        @layout = "mobile"
        @controller.prepend_view_path "app/views/mobile"
      end
    end

    def mobile?
      @layout == "mobile"
    end

    def wechat?
      # @wechat
      false
    end
  end
end
