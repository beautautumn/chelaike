# copy from https://gist.github.com/ericchen/3081968
module Util
  class AesCrypt
    class << self
      def encrypt(password, iv, cleardata)
        cipher = OpenSSL::Cipher.new("AES-256-CBC")
        # set cipher to be encryption mode
        cipher.encrypt
        cipher.key = password
        cipher.iv  = iv

        encrypted = ""
        encrypted << cipher.update(cleardata)
        encrypted << cipher.final
        AesCrypt.b64enc(encrypted)
      end

      def decrypt(password, iv, secretdata)
        secretdata = UrlSafeBase64.decode64(secretdata)
        decipher = OpenSSL::Cipher::Cipher.new("aes-256-cbc")
        decipher.decrypt
        decipher.key = password
        decipher.iv = iv if iv.present?
        decipher.update(secretdata) + decipher.final
      end

      def b64enc(data)
        UrlSafeBase64.encode64(data)
      end
    end
  end
end
