namespace :company do
  desc "初始化公司的app_secret"
  task app_secret: :environment do
    Company.find_each(batch_size: 50) do |c|
      c.update_columns(app_secret: SecureRandom.hex)
    end
  end

  task intention_level: :environment do
    Company.find_each(batch_size: 50) do |company|
      User::RegistrationService.init_intention_levels(company)
    end
  end

  desc "给所有公司创建聊天组"
  task init_groups: :environment do
    Company.find_each(batch_size: 100) do |company|
      %w(sale acquisition).each do |chat_type|
        begin
          ChatGroup::ManageService.new(
            "enable",
            company,
            chat_type
          ).execute
        rescue
          puts "company: #{company.id} 不能创建聊天组"
        end
      end
    end
  end

  desc "更新公司official_website_url"
  task update_official_website_url: :environment do
    Company::OfficialWebsiteUrlService.new.execute
  end

  desc "每日服务提醒, 包括整备完成, 意向跟进到期"
  task daily_reminder: :environment do
    Company.find_each do |company|
      Company::DailyReminderService.new(company).execute
    end
  end
end
