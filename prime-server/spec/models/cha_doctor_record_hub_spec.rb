# == Schema Information
#
# Table name: cha_doctor_record_hubs # 查博士报告
#
#  id                  :integer          not null, primary key # 查博士报告
#  vin                 :string                                 # vin码
#  brand_name          :string                                 # 品牌
#  engine_no           :string                                 # 发动机号
#  license_plate       :string                                 # 车牌号
#  sent_at             :datetime                               # 请求发送时间
#  order_id            :string                                 # 订单ID
#  make_report_at      :datetime                               # 报告生成时间
#  report_no           :string                                 # 报告编号
#  report_details      :jsonb                                  # 详细报告
#  pc_url              :string                                 # 生成报告的电脑端URL
#  mobile_url          :string                                 # 生成报告的手机端URL
#  fetch_info_at       :datetime                               # 拉取报告的时间
#  notify_at           :datetime                               # 通知回调时间
#  order_status        :string                                 # 查询结果状态码
#  order_message       :string                                 # 查询结果对应消息
#  notify_status       :string                                 # 异步回调结果状态
#  notify_message      :string                                 # 异步回调结果消息
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  order_state         :string                                 # 购买报表同步返回结果的状态
#  notify_state        :string                                 # 购买报表异步通知结果的状态
#  series_name         :string                                 # 车系名
#  style_name          :string                                 # 车型
#  summany_status_data :jsonb                                  # 概况的状态
#

require "rails_helper"

RSpec.describe ChaDoctorRecordHub, type: :model do
  let(:vin) { "LFPH3ACC7A1A61382" }

  before do
    @hub = ChaDoctorRecordHub.create!(vin: vin,
                                      notify_state: :success)
  end

  describe ".available_hub(vin)" do
    it "得到未过期的报告" do
      result = ChaDoctorRecordHub.available_hub(vin)
      expect(result).to eq @hub
    end

    it "得不到过期报告" do
      @hub.update(created_at: Time.zone.today - (ChaDoctorRecordHub::EXPERATION + 1.day))
      result = ChaDoctorRecordHub.available_hub(vin)
      expect(result).to be_nil
    end

    it "得到的报告应该是最新的一份" do
      ChaDoctorRecordHub.create(vin: vin, created_at: 1.hour.ago)
      result = ChaDoctorRecordHub.available_hub(vin)
      expect(result).to eq @hub
    end
  end
end
