Rongcloud.configure do |config|
  config.app_key = ENV.fetch("RONGCLOUD_APP_KEY")
  config.app_secret = ENV.fetch("RONGCLOUD_SECRET")
end

Rongcloud.configure do |config|
  config.app_key = ENV.fetch("EASY_LOAN_RONG_CLOUD_APP_KEY")
  config.app_secret = ENV.fetch("EASY_LOAN_RONG_CLOUD_SECRET")
  config.platform = :easy_loan
end
