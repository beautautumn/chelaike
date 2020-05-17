namespace :expiration_notification do
  desc "每天发送到期提醒"
  task run: :environment do
    ExpirationNotificationService::Scan.scan
  end
end
