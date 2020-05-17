# == Schema Information
#
# Table name: easy_loan_debits # 借款方统计信息
#
#  id                    :integer          not null, primary key # 借款方统计信息
#  inventory_amount      :integer                                # 计算月库存资金量
#  operating_health      :decimal(, )                            # 计算月经营健康评级
#  industry_rating       :decimal(, )      default(3.0)          # 设置借方行业风评
#  assets_debts_rating   :decimal(, )      default(0.6)          # 设置借方资产负债率
#  comprehensive_rating  :decimal(, )                            # 计算月综合评级
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  company_id            :integer                                # 统计数据和公司关联
#  beat_global           :decimal(, )                            # 综合评分打败全国车商数据
#  beat_local            :decimal(, )                            # 综合评分打败本地车商数据
#  real_inventory_amount :integer                                # 真实库存资金量数据
#  cash_turnover_rate    :decimal(, )                            # 资金周转率
#  car_gross_profit_rate :decimal(, )                            # 月利润率
#

require "rails_helper"

RSpec.describe EasyLoan::Debit, type: :model do
  fixtures :all
  let(:tianche) { companies(:tianche) }
  let(:debit) { easy_loan_debits(:debit_a)}

  describe ".rating_statements_text" do
    it "得到评分对应文字内容" do
      EasyLoan::RatingStatement.create!(
        score: 3, rate_type: :comprehensive_rating,
        content: "comprehensive_rating ranking less than 3"
      )

      EasyLoan::RatingStatement.create!(
        score: 4, rate_type: :operating_health,
        content: "operating_health ranking less than 4"
      )

      EasyLoan::RatingStatement.create!(
        score: 5, rate_type: :industry_rating,
        content: "industry_rating ranking less than 5"
      )

      debit = EasyLoan::Debit.create!(
        company_id: tianche.id,
        comprehensive_rating: 3.7,
        operating_health: 3.6,
        industry_rating: 4.9
      )

      expect(debit.rating_statements_text).to be_present
    end
  end

  describe "#with_year_and_month and #with_date_and_company" do
    it "return current_month debits" do
      expect(EasyLoan::Debit.with_year_and_month(Time.now.year, Time.now.month).count).to eq(2)
    end

    it "return current_month with specify company_id" do
      expect(EasyLoan::Debit.with_date_and_company(tianche.id, Time.now.year, Time.now.month).count).to eq(1)
    end
  end
end
