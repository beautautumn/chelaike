require "rails_helper"

class WechatTestClass
  include Wechat::Crypto

  def test_decrypt(encrypted_message)
    decrypt(encrypted_message)
  end

  def test_encrypt(message)
    encrypt(message)
  end
end

RSpec.describe "微信消息加解密" do
  let(:wechat_test) { WechatTestClass.new }

  describe "signature" do
    it "生成合法签名" do
      signature = "3f11d2c3228b365849fdec3663a0d2de27a23ee2"
      timestamp = "1449553252"
      nonce = "70172940"

      expect(wechat_test.generate_signature(
               timestamp, nonce, Wechat::WECHAT_TOKEN))
        .to eq signature
    end
  end

  describe "decrypt" do
    it "消息解密" do
      encrypted_message = <<-MESSAGE.strip_heredoc.delete("\n")
        gdJj2Uc4uqBw/Q7fEeFcbfQOINV63fx56YgaIDjuYHy/Wc9g2z7m9hIRIK7NEXLJzXeCe1c/
        21nh1kScaNrhhp6OHlp4FlMI9JNonHusQvLYbhXCmHHTSXNSsQYYOs+E1mPxze+DqVOkKIxD
        8JxF43YTbRSRbGPSyA4hgFc1EQPSCFhGOiA1Z9kzrLfhGFY15rj3IGkzuFZMxMeGLqXcBcmS
        u8f662cHjxTcZyzZJaZw4MmUdJWRWlLFAgjykgjQmC3fS9mI3WLmsEJaBULhawFK25CAjf5d
        4nCA2AtAnmKZ1mDj7PcXKeLSkGUcZP8JwzuYdap9URmq0JUMltWuTse+QD3KsYm3dUg/K+zV
        C2WR5ez+d84+Dj12FXZMJobRY8TYGHTCj7BA0P69rBqInr5qHxyN5uuhWYHLeqfRSuloU3DI
        bkj2qZ7iG34vNMHVO/FWR44+mRqjpvcRB8dwpA==
      MESSAGE

      message = wechat_test.decrypt(encrypted_message)

      expect(message["AppId"]).to eq "wxefe9e45b217bc492"
    end
  end

  describe "encrypt" do
    it "消息加密" do
      message = <<-XML.strip_heredoc.delete("\n")
        <xml>
          <AppId><![CDATA[wxefe9e45b217bc492]]></AppId>
          <CreateTime>1449727252</CreateTime>
          <InfoType><![CDATA[component_verify_ticket]]></InfoType>
          <ComponentVerifyTicket>
            <![CDATA[ticket@@@G2WqLKmALSn8c5nNGjwPbQNOWbTbGl_UtVn0vELuGUcNIRTyNI
            MD6z7mnJwHgEYDtNia_cs9wPgX8YOjgbwypg]]>
          </ComponentVerifyTicket>
        </xml>
      XML
      origin_message = Hash.from_xml(message)["xml"]

      encrypted_message = wechat_test.test_encrypt(message)
      decrypted_message = wechat_test.test_decrypt(encrypted_message)

      expect(decrypted_message).to eq origin_message
    end
  end
end
