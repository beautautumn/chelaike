# == Schema Information
#
# Table name: maintenance_records # 维保记录
#
#  id                             :integer          not null, primary key # 维保记录
#  company_id                     :integer                                # 公司ID
#  car_id                         :integer                                # 车辆ID
#  vin                            :string
#  state                          :string
#  last_fetch_by                  :integer                                # 最后查询的用户ID
#  user_name                      :string                                 # 最后查询的用户名
#  last_fetch_at                  :datetime                               # 最后查询的时间
#  maintenance_record_hub_id      :integer
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  engine                         :string                                 # 发动机
#  license_plate                  :string                                 # 车牌
#  last_maintenance_record_hub_id :integer
#  shop_id                        :integer
#  token_price                    :decimal(8, 2)
#  pre_token_price                :decimal(8, 2)
#  vin_image                      :string                                 # vin码图片地址
#  token_type                     :string                                 # 支付token的类型
#  token_id                       :integer                                # 支付token
#

require "rails_helper"

RSpec.describe MaintenanceRecord, type: :model do
  fixtures :all

  let(:maintenance_record_uncheck) { maintenance_records(:maintenance_record_uncheck) }

  describe ".shared_key" do
    it "根据平台，id编码为一个key" do
      shared_key = MaintenanceRecord.shared_key(1, maintenance_record_uncheck.id)
      expect(shared_key).to be_present
    end
  end
end
