require "carrierwave/orm/activerecord"
CarrierWave.configure do |config|
  config.storage           = :aliyun
  config.aliyun_access_id  = ENV["OSS_ACCESS_KEY_ID"]
  config.aliyun_access_key = ENV["OSS_ACCESS_KEY_SECRET"]
  # 你需要在 Aliyum OSS 上面提前创建一个 Bucket
  config.aliyun_bucket     = ENV["OSS_BUCKET_NAME"]
  # 是否使用内部连接，true - 使用 Aliyun 主机内部局域网的方式访问  false - 外部网络访问
  config.aliyun_internal   = ENV["OSS_ACCESS_INTERNAL"].present?
  # 配置存储的地区数据中心，默认: cn-hangzhou
  # config.aliyun_area     = "cn-hangzhou"
  # 使用自定义域名，设定此项，carrierwave 返回的 URL 将会用自定义域名
  # 自定于域名请 CNAME 到 you_bucket_name.oss-cn-hangzhou.aliyuncs.com (you_bucket_name 是你的 bucket 的名称)
  config.aliyun_host       = ENV["IMAGE_HOST"]
  # Bucket 为私有读取请设置 true，默认 false，以便得到的 URL 是能带有 private 空间访问权限的逻辑
  # config.aliyun_private_read = false
end
