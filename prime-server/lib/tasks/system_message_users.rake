namespace :system_users do
  desc "创建系统消息用户"
  task init: :environment do
    domain = "http://image.chelaike.com"

    users_hash = {
      统计消息: {
        id: -100, username: "统计消息",
        name: "统计消息", phone: "statistics_messager",
        password: "e5f732bea0edc282fd9d",
        avatar: "#{domain}/images/statistics.png"
      },
      库存消息: {
        id: -200, username: "库存消息",
        name: "库存消息", phone: "stock_messager",
        password: "463af81dca326aff30fb",
        avatar: "#{domain}/images/stock.png"
      },
      客户消息: {
        id: -300, username: "客户消息",
        name: "客户消息", phone: "customer_messager",
        password: "77e304e80b2078e488c7",
        avatar: "#{domain}/images/customer.png"
      },
      系统消息: {
        id: -400, username: "系统消息",
        name: "系统消息", phone: "system_messager",
        password: "fa494f72fd883fb9c9cf",
        avatar: "#{domain}/images/system.png"
      },
      金融消息: {
        id: -500, username: "库融消息",
        name: "库融消息", phone: "loan_messager",
        password: "0a0f8f2bf97c35c49d6b",
        avatar: "#{domain}/images/loan.png"
      }
    }

    users_hash.each do |key, value|
      next if User.exists?(username: key)
      User.create!(value)
    end
  end

  desc "创建车融易系统消息用户"
  task init_easy_loan: :environment do
    EasyLoan::User.find_or_create_by!(
      id: -100, name: "系统消息用户",
      phone: "22222222222"
    )
  end
end
