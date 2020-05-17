AutohomePublicPraise.aliyun_oss_configure do |config|
  config.endpoint = ENV.fetch("OSS_ENDPOINT")
  config.access_key_id = ENV.fetch("ACCESS_KEY_ID")
  config.access_key_secret = ENV.fetch("ACCESS_KEY_SECRET")
end
