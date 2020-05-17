# frozen_string_literal: true
require "roxml"

# <xml>
# <ToUserName><![CDATA[toUser]]></ToUserName>
# <FromUserName><![CDATA[fromUser]]></FromUserName>
# <CreateTime>12345678</CreateTime>
# <MsgType><![CDATA[news]]></MsgType>
# <ArticleCount>2</ArticleCount>
# <Articles>
# <item>
# <Title><![CDATA[title1]]></Title>
# <Description><![CDATA[description1]]></Description>
# <PicUrl><![CDATA[picurl]]></PicUrl>
# <Url><![CDATA[url]]></Url>
# </item>
# <item>
# <Title><![CDATA[title]]></Title>
# <Description><![CDATA[description]]></Description>
# <PicUrl><![CDATA[picurl]]></PicUrl>
# <Url><![CDATA[url]]></Url>
# </item>
# </Articles>
# </xml>
module Wechat
  module Message
    class Articles < Base
      xml_accessor :ArticleCount, as: Integer
      xml_accessor :Articles, as: [ArticleItem], in: "Articles", from: "item"
      # rubocop:disable Style/VariableName
      def initialize
        super
        @MsgType = "news"
      end
      # rubocop:enable Style/VariableName
    end
  end
end
