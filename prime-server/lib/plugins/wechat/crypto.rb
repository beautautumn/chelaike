module Wechat
  module Crypto
    def generate_signature(*keys)
      key = keys.sort.join
      Digest::SHA1.hexdigest(key)
    end

    def decrypt(encrypted_message)
      message = Base64.decode64(encrypted_message)
      aes_key = Base64.decode64(WECHAT_AES_KEY + "=")

      message = handle_cipher(:decrypt, aes_key, message)
      message = pkcs7_decode(message)

      message = message[16..-1]
      xml_len = message[0...4].unpack("N")[0]
      xml_content = message[4...4 + xml_len]

      Hash.from_xml(xml_content)["xml"]
    end

    def encrypt(message)
      message = message.force_encoding("ASCII-8BIT")
      aes_key = Base64.decode64(WECHAT_AES_KEY + "=")

      random = SecureRandom.hex(8)
      message_length = [message.length].pack("N")

      message = "#{random}#{message_length}#{message}#{Wechat::WECHAT_ID}"
      message = pkcs7_encode(message)
      message = handle_cipher(:encrypt, aes_key, message)
      Base64.encode64(message)
    end

    private

    def handle_cipher(action, aes_key, message)
      cipher = OpenSSL::Cipher.new("AES-256-CBC")
      cipher.send(action)
      cipher.padding = 0
      cipher.key = aes_key
      cipher.iv  = aes_key[0...16]
      cipher.update(message) + cipher.final
    end

    def pkcs7_decode(message)
      pad = message[-1].ord
      pad = 0 if pad < 1 || pad > 32
      size = message.size - pad

      message[0...size]
    end

    def pkcs7_encode(message)
      amount_to_pad = 32 - (message.length % 32)
      amount_to_pad = 32 if amount_to_pad == 0

      pad_chr = amount_to_pad.chr

      "#{message}#{pad_chr * amount_to_pad}"
    end
  end
end
