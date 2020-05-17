# frozen_string_literal: true
module Wechat
  module Reply
    include Crypto

    def reply_text_message(from:, to:, content:)
      message = Wechat::Message::Text.new
      message.FromUserName = from
      message.ToUserName   = to
      message.Content      = content
      encrypt_message(message.to_xml)
    end

    def reply_articles_message(from:, to:, articles:)
      articles = Array.wrap(articles)
      message = Wechat::Message::Articles.new
      message.FromUserName = from
      message.ToUserName   = to
      message.Articles     = articles
      message.ArticleCount = articles.count
      encrypt_message(message.to_xml)
    end

    def generate_article(title:, desc:, pic_url:, link_url:)
      item = Wechat::Message::ArticleItem.new
      item.Title       = title
      item.Description = desc
      item.PicUrl = pic_url
      item.Url    = link_url
      item
    end

    def reply_transfer_customer_service_message(from:, to:)
      message = Wechat::Message::TransferCustomerService.new
      message.FromUserName = from
      message.ToUserName   = to
      encrypt_message message.to_xml
    end

    private

    def encrypt_message(msg_xml)
      # 加密回复的XML
      encrypt_xml = encrypt(msg_xml)
      # 标准的回包
      generate_encrypt_message(encrypt_xml)
    end

    def generate_encrypt_message(encrypt_xml)
      msg              = Wechat::Message::EncryptMessage.new
      msg.Encrypt      = encrypt_xml
      msg.TimeStamp    = Time.zone.now.to_i
      msg.Nonce        = SecureRandom.hex(8)
      msg.MsgSignature = generate_msg_signature(encrypt_xml, msg)
      msg.to_xml
    end

    # dev_msg_signature=sha1(sort(token、timestamp、nonce、msg_encrypt))
    # 生成企业签名
    def generate_msg_signature(encrypt_msg, msg)
      generate_signature(Wechat::WECHAT_TOKEN, msg.TimeStamp.to_s,
                         msg.Nonce, encrypt_msg)
    end
  end
end
