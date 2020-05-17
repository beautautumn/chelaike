# == Schema Information
#
# Table name: finance_shop_fees # 单店运营运营成本和收益
#
#  id                       :integer          not null, primary key # 单店运营运营成本和收益
#  shop_id                  :integer                                # 关联分店
#  month                    :string                                 # 年月
#  location_rent_cents      :integer                                # 场地租金
#  salary_cents             :integer                                # 固定工资
#  social_insurance_cents   :integer                                # 社保／公积金
#  bonus_cents              :integer                                # 奖金／福利
#  marketing_expenses_cents :integer                                # 市场营销
#  energy_fee_cents         :integer                                # 水电
#  office_fee_cents         :integer                                # 办公用品
#  communication_fee_cents  :integer                                # 通讯费
#  other_cost_cents         :integer                                # 其它支出
#  other_profit_cents       :integer                                # 其它收入
#  note                     :text                                   # 备注
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#

require "rails_helper"

RSpec.describe Finance::ShopFee, type: :model do
  fixtures :all
  let(:disney_shop_fee_j) { finance_shop_fees(:disney_shop_fee_j) }

  describe "#increase_profit_and_cost!" do
    it "增加单店单月的收益" do
      disney_shop_fee_j.add_profit 5000000

      disney_shop_fee_j.add_profit 6300000
      expect(disney_shop_fee_j.sales_revenue_wan).to eq 11.3
    end

    it "增加单店单月的成本" do
      disney_shop_fee_j.add_cost 5000000

      disney_shop_fee_j.add_cost 6000000
      expect(disney_shop_fee_j.car_cost_wan).to eq 11
    end
  end
end
