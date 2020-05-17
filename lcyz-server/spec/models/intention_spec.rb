# == Schema Information
#
# Table name: intentions # 意向
#
#  id                            :integer          not null, primary key     # 意向
#  customer_id                   :integer                                    # 客户ID
#  customer_name                 :string                                     # 客户姓名
#  intention_type                :string                                     # 意向类型
#  creator_id                    :integer                                    # 意向创建者
#  assignee_id                   :integer                                    # 分配员工ID
#  province                      :string                                     # 省份
#  city                          :string                                     # 城市
#  intention_level_id            :integer                                    # 意向级别ID
#  channel_id                    :integer                                    # 客户渠道
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  company_id                    :integer                                    # 公司ID
#  shop_id                       :integer                                    # 店ID
#  customer_phones               :string           default([]), is an Array  # 客户联系方式
#  state                         :string           default("pending")        # 跟进状态
#  customer_phone                :string                                     # 客户电话
#  intention_note                :text                                       # 意向描述
#  gender                        :string                                     # 性别
#  brand_name                    :string                                     # 出售车辆品牌名称
#  series_name                   :string                                     # 出售车辆车系名称
#  color                         :string                                     # 颜色
#  mileage                       :float                                      # 里程(万公里)
#  licensed_at                   :date                                       # 上牌日期
#  minimum_price_cents           :integer                                    # 最低价格
#  maximum_price_cents           :integer                                    # 最高价格
#  estimated_price_cents         :integer                                    # 评估车价
#  seeking_cars                  :jsonb            is an Array               # 求购车辆
#  style_name                    :string                                     # 出售车辆车款名称
#  interviewed_time              :datetime                                   # 预约时间
#  processing_time               :datetime                                   # 跟进时间
#  checked_count                 :integer          default(0)                # 到店/评估次数
#  consigned_at                  :date                                       # 寄卖时间
#  deleted_at                    :datetime                                   # 删除时间
#  source                        :string           default("user_operation") # 意向产生来源
#  import_task_id                :integer                                    # 意向导入记录ID
#  source_car_id                 :integer                                    # 来源车辆ID
#  source_company_id             :integer                                    # 来源公司ID
#  deposit_cents                 :integer                                    # 定金
#  closing_cost_cents            :integer                                    # 成交价格
#  closing_car_id                :integer                                    # 成交车辆ID
#  closing_car_name              :string                                     # 成交车辆名称
#  creator_type                  :string                                     # 意向创建者多态
#  alliance_company_id           :integer
#  alliance_assignee_id          :integer                                    # 联盟用户ID
#  earnest                       :boolean          default(FALSE)            # 是否已收意向金
#  alliance_assigned_at          :datetime                                   # 分配给车商的时间
#  in_shop_at                    :datetime                                   # 客户到店时间
#  alliance_state                :string                                     # 联盟意向状态
#  alliance_intention_level_id   :integer
#  annual_inspection_notify_date :date                                       # 年审到期提醒日期
#  insurance_notify_date         :date                                       # 保险到期提醒日期
#  mortgage_notify_date          :date                                       # 按揭到期提醒日期
#  after_sale_assignee_id        :integer                                    # 服务归属人ID
#

require "rails_helper"

RSpec.describe Intention, type: :model do
  fixtures :all

  let(:doraemon) { customers(:doraemon) }
  let(:doraemon_seeking_aodi) { intentions(:doraemon_seeking_aodi) }
  let(:gian_seeking_aodi) { intentions(:gian_seeking_aodi) }
  let(:zhangsan) { users(:zhangsan) }
  let(:lisi) { users(:lisi) }
  let(:nolan) { users(:nolan) }
  let(:shared_intention) { intention_shared_users(:doraemon_seeking_aodi_share_to_lisi) }

  describe "#seeking_car_price_condition" do
    it "creates a sql" do
      result = [
        "cars.show_price_cents >= '20000000'",
        "cars.show_price_cents <= '20000000'"
      ].join(" AND ")

      expect(doraemon_seeking_aodi.seeking_car_price_condition).to eq result
    end
  end

  describe "#seeking_cars_condition" do
    it "create a sql" do
      result = <<-SQL.squish
        cars.show_price_cents >= '20000000' AND
        cars.show_price_cents <= '20000000' AND
        (cars.brand_name = '奥迪' AND cars.series_name = '奥迪A3') OR
        (cars.brand_name = '大众' AND cars.series_name = '宝来')
      SQL

      expect(doraemon_seeking_aodi.seeking_cars_condition).to eq result
    end
  end

  describe "Struct SeekingCar" do
    let(:seeking_car) { Intention::SeekingCar.new("大众", "宝来") }

    context "#to_sql" do
      it "generates the right SQL" do
        expect(seeking_car.to_sql).to eq "(cars.brand_name = '大众' AND cars.series_name = '宝来')"
      end
    end
  end

  describe "#shared_users" do
    it "得到这个意向共享人列表" do
      expect(doraemon_seeking_aodi.shared_users).to include lisi
    end
  end

  describe "expiration" do
    it "得到过期意向列表" do
      expect(Intention.to_be_recycled(3.days)).to include gian_seeking_aodi
    end
  end
end
