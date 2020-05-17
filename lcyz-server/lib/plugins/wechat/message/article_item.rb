require "roxml"

module Wechat
  module Message
    class ArticleItem
      include ROXML
      xml_accessor :Title, cdata: true
      xml_accessor :Description, cdata: true
      xml_accessor :PicUrl, cdata: true
      xml_accessor :Url,    cdata: true
    end
  end
end
