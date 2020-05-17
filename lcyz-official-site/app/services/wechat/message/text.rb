# frozen_string_literal: true
require "roxml"

# <xml>
# <ToUserName><![CDATA[toUser]]></ToUserName>
# <FromUserName><![CDATA[fromUser]]></FromUserName>
# <CreateTime>12345678</CreateTime>
# <MsgType><![CDATA[text]]></MsgType>
# <Content><![CDATA[Hello]]></Content>
# </xml>c
module Wechat
  module Message
    class Text < Base
      xml_accessor :Content, cdata: true
      # rubocop:disable Style/VariableName
      def initialize
        super
        @MsgType = "text"
      end
      # rubocop:enable Style/VariableName
    end
  end
end
