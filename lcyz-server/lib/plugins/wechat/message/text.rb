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
      def initialize
        super
        @MsgType = "text"
      end
    end
  end
end
