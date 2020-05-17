# 套餐数值需要小心
namespace :token_packages do
  task import: :environment do
    [%w(290元 充值290元得320车币 赠送30车币 29000 290 30),
     %w(580元 充值580元得650车币 赠送70车币 58000 580 70),
     %w(1160元 充值1160元得1320车币 赠送160车币 116000 1160 160),
     %w(2320元 充值2320元得2670车币 赠送350车币 232000 2320 350)].each do |attrs|
      TokenPackage.create(name: attrs[0],
                          title: attrs[1],
                          description: attrs[2],
                          price_cents: attrs[3],
                          balance: attrs[4],
                          extra_balance: attrs[5])
    end
  end
end
