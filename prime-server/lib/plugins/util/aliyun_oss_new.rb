module Util
  class AliyunOssNew
    attr_reader :client, :filename

    def initialize(object_key)
      @filename = object_key.to_s

      @client = Aliyun::OSS::Client.new(
        endpoint: ENV["OSS_ENDPOINT"],
        access_key_id: ENV["ACCESS_KEY_ID"],
        access_key_secret: ENV["ACCESS_KEY_SECRET"]
      )
    end

    def upload(io_stream)
      bucket = client.get_bucket("tianche-playground")

      bucket.put_object(filename) { |stream| stream << io_stream }

      "http://tianche-playground.oss-cn-hangzhou.aliyuncs.com/#{filename}"
    end
  end
end
