# == Schema Information
#
# Table name: finance_car_incomes # 财务管理-单车成本和收益
#
#  id                      :integer          not null, primary key # 财务管理-单车成本和收益
#  car_id                  :integer                                # 关联车辆
#  company_id              :integer                                # 所属公司
#  payment_cents           :integer                                # 入库付款
#  prepare_cost_cents      :integer                                # 整备费用
#  handling_charge_cents   :integer                                # 手续费
#  commission_cents        :integer                                # 佣金
#  percentage_cents        :integer                                # 提成/分成
#  fund_cost_cents         :integer                                # 资金成本
#  other_cost_cents        :integer                                # 其他成本
#  receipt_cents           :integer                                # 出库收款
#  other_profit_cents      :integer                                # 其他收益
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  acquisition_price_cents :integer                                # 收购价格
#  closing_cost_cents      :integer                                # 成交价格
#  fund_rate               :decimal(, )                            # 单车对应的资金利率
#  loan_cents              :integer                                # 单车融资数额
#

require "rails_helper"

RSpec.describe Finance::CarIncome, type: :model do
  fixtures :all

  let(:aodi_sold_income) { finance_car_incomes(:aodi_sold_income) }
  let(:aodi) { cars(:aodi_sold) }
  let(:tianche) { companies(:tianche) }

  describe "#increase_amount!" do
    it "根据项目类型增加相应的款项金额" do
      aodi_sold_income.update(prepare_cost_yuan: 30)
      aodi_sold_income.increase_amount!(:prepare_cost, 20.1)
      expect(aodi_sold_income.reload.prepare_cost_yuan).to eq 50.1
    end
  end

  describe "#set_fund_rate" do
    it "根据公司财务配置, 设置资金利率" do
      aodi_sold_income.save
      expect(aodi_sold_income.fund_rate).to eq 1.0 # 默认值
    end

    it "可以接受收购价为空" do
      aodi_sold_income.acquisition_price_cents = nil
      expect { aodi_sold_income.save! }.not_to raise_error
    end
  end
end
