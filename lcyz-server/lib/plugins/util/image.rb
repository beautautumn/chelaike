module Util
  class Image
    def self.base64(url)
      Base64.encode64 RestClient.get url, timeout: 5
    end
  end
end
