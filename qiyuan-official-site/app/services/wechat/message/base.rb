# frozen_string_literal: true
require "roxml"

module Wechat
  module Message
    class Base
      include ROXML
      xml_name :xml

      xml_accessor :ToUserName, cdata: true
      xml_accessor :FromUserName, cdata: true
      xml_reader   :CreateTime, as: Integer
      xml_reader   :MsgType, cdata: true

      # rubocop:disable Style/VariableName
      def initialize
        @CreateTime = Time.zone.now.to_i
      end
      # rubocop:enable Style/VariableName

      def to_xml
        super.to_xml(encoding: "UTF-8", indent: 0, save_with: 0)
      end
    end
  end
end
