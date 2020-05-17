namespace :users do
  desc "查询密码简单用户"
  task password_finder: :environment do
    def possible_passwords(user)
      arr = [
        user.phone,
        "123456",
        "1234567",
        "12345678",
        "123456789",
        "1234567890",
        user.name,
        user.username,
        user.email,
        user.phone.reverse,
        "012345",
        "0123456",
        "01234567",
        "012345678",
        "0123456789"
      ]

      arr.flatten.uniq
    end

    def row(user)
      possible_passwords(user).each do |password|
        next unless user.authenticate(password)
        result = [
          user.company.name,
          user.username,
          user.name,
          user.phone
        ]

        return result
      end

      []
    end

    CSV.open("#{Rails.root}/log/password_too_simple.csv", "wb") do |csv|
      csv << %w(公司名 用户名 名字 手机号码)

      User.includes(:company).find_each do |user|
        result = row(user)

        csv << result if result.present?
      end
    end
  end
end
