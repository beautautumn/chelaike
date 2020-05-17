namespace :xiaocheche do
  desc "创建车小小账号"
  task init: :environment do
    company_id = Rails.env == "production" ? 6 : 4
    company = Company.find(company_id)
    user = company.users.where(username: "小车车").first
    user = company.users.create!(
      name: "小车车",
      username: "小车车",
      phone: "xiaocheche",
      password: "xiaocheche"
    ) unless user

    token = ChatService::User.new(user).rc_token
    puts "小车车已创建，rc_token: #{token}"
  end
end
