require "rails_helper"

RSpec.describe FinanceShopFeeWorker do
  fixtures :all

  it "create shop fees for current month" do
    FinanceShopFeeWorker.new.perform

    expect(Shop.count).to eq ::Finance::ShopFee.where(month: Time.zone.now.strftime("%Y-%m")).count
  end
end
