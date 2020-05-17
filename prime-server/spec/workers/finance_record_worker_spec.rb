require "rails_helper"

RSpec.describe FinanceRecordWorker do
  fixtures :all
  let(:tianche) { companies(:tianche) }
  let(:aodi) { cars(:aodi) }

  it "创建财务记录, 如果不设利率/借贷则不生成财务成本" do
    FinanceRecordWorker.new.perform(tianche.id)
    expect(aodi.finance_car_income).to be_present
    expect(aodi.finance_car_fees.where(category: "fund_cost")).to be_blank
  end
end
