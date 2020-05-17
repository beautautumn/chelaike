# == Schema Information
#
# Table name: dashenglaile_records # 大圣来了记录
#
#  id                              :integer          not null, primary key # 大圣来了记录
#  company_id                      :integer                                # 公司ID
#  car_id                          :integer                                # 车辆ID
#  shop_id                         :integer                                # 店铺ID
#  vin                             :string                                 # vin码
#  engine_num                      :string                                 # 发动机号
#  car_brand_id                    :integer                                # 大圣来了品牌 ID
#  state                           :string                                 # 查询状态
#  last_fetch_by                   :integer                                # 最后查询的用户ID
#  user_name                       :string                                 # 最后查询的用户名
#  last_fetch_at                   :datetime                               # 最后查询的时间
#  dashenglaile_record_hub_id      :integer                                # 所属报告
#  last_dashenglaile_record_hub_id :integer                                # 最近更新的报告
#  token_price                     :decimal(8, 2)                          # 查询价格
#  vin_image                       :string                                 # vin码图片地址
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  action_type                     :string           default("new")        # 记录的查询类型
#  payment_state                   :string           default("unpaid")     # 支付状态
#  pre_token_price                 :decimal(8, 2)                          # 原价
#  request_at                      :datetime                               # 请求时间
#  response_at                     :datetime                               # 返回时间
#  token_type                      :string                                 # 支付token的类型
#  token_id                        :integer                                # 支付token
#

require "rails_helper"

RSpec.describe DashenglaileRecord, type: :model do
  fixtures :dashenglaile_record_hubs, :dashenglaile_records,
           :users

  let(:record_test) { dashenglaile_records(:dashenglaile_record_test) }
  let(:record_production) { dashenglaile_records(:dashenglaile_record_uncheck) }

  let(:token) { Token.create(company_id: lisi.company_id, balance: 100000) }
  describe "car_status" do
    it "matches test" do
      t1 = [{ title: "结构部件", desc: "正常", status: 1 },
            { title: "发动机", desc: "正常", status: 1 },
            { title: "里程数", desc: "正常", status: 1 },
            { title: "安全气囊", desc: "异常", status: 0 }]
      expect(record_test.car_status).to eq t1
    end

    it "matches production" do
      t2 = [{ title: "结构部件", desc: "正常", status: 1 },
            { title: "发动机", desc: "正常", status: 1 },
            { title: "里程数", desc: "异常", status: 0 },
            { title: "安全气囊", desc: "正常", status: 1 }]
      expect(record_production.car_status).to eq t2
    end
  end
end
