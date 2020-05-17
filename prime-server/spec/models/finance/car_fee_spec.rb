# == Schema Information
#
# Table name: finance_car_fees # 车辆费用
#
#  id           :integer          not null, primary key # 车辆费用
#  car_id       :integer                                # 关联车辆
#  creator_id   :integer                                # 项目创建者
#  category     :string                                 # 所属项目分类
#  item_name    :string                                 # 具体项目名
#  amount_cents :integer                                # 费用数额
#  fee_date     :date                                   # 费用日期
#  note         :text                                   # 说明
#  user_id      :integer                                # 关联用户
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require "rails_helper"

RSpec.describe Finance::CarFee, type: :model do
  fixtures :all
  let(:aodi) { cars(:aodi) }

  describe "payments" do
    it "create and get payments" do
      aodi.finance_car_fees.create(
        category: "payment",
        fee_date: Date.new(2016, 8, 3),
        amount_wan: 1,
        note: "付款一万"
      )

      expect(aodi.finance_car_fees.payment.count).to eq 1
      expect(aodi.finance_car_fees.payment.first.amount_wan).to eq 1
    end
  end
end
