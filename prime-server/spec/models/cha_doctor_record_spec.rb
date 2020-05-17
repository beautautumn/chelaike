# == Schema Information
#
# Table name: cha_doctor_records
#
#  id                            :integer          not null, primary key
#  company_id                    :integer                                # 公司ID
#  car_id                        :integer                                # 车辆ID
#  shop_id                       :integer                                # 店铺ID
#  vin                           :string
#  state                         :string
#  user_name                     :string                                 # 查询的用户名
#  user_id                       :integer                                # 查询的用户ID
#  fetch_at                      :datetime                               # 拉取报告的时间
#  cha_doctor_record_hub_id      :integer                                # 所属报告
#  last_cha_doctor_record_hub_id :integer                                # 最新更新的报告
#  engine_num                    :string                                 # 发动机号
#  token_price                   :decimal(8, 2)
#  vin_image                     :string                                 # vin码图片
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  action_type                   :string           default("new")        # 记录的查询类型
#  payment_state                 :string           default("unpaid")     # 支付状态
#  request_at                    :datetime                               # 请求时间
#  response_at                   :datetime                               # 返回时间
#  token_type                    :string
#  token_id                      :integer
#

require "rails_helper"

RSpec.describe ChaDoctorRecord, type: :model do
  fixtures :all

  let(:cha_doctor_record_hub) { cha_doctor_record_hubs(:cha_doctor_record_hub) }
  let(:cha_doctor_record) { cha_doctor_records(:cha_doctor_record_uncheck) }

  describe "#process_result" do
    context "hub通知失败" do
      before do
        cha_doctor_record_hub.update!(notify_state: :failed)
      end

      context "查询类型是new" do
        it "相应更新" do
          cha_doctor_record.update!(action_type: :new)
          cha_doctor_record.process_result(cha_doctor_record_hub)
          expect(cha_doctor_record.reload.state).to eq "generating_fail"
        end
      end

      context "查询类型是refetch" do
        it "所属报告为之前报告，最新报告" do
          cha_doctor_record.update!(action_type: :refetch,
                                    cha_doctor_record_hub_id: 1,
                                    last_cha_doctor_record_hub_id: cha_doctor_record_hub.id)
          cha_doctor_record.process_result(cha_doctor_record_hub)
          expect(cha_doctor_record.reload.cha_doctor_record_hub_id).to eq 1
          expect(cha_doctor_record.last_cha_doctor_record_hub_id).to eq 1
          expect(cha_doctor_record.state).to eq "updating_fail"
        end
      end
    end

    context "hub通知成功" do
      before do
        cha_doctor_record_hub.update!(notify_state: :success)
      end

      context "查询类型是new" do
        it "相应更新" do
          cha_doctor_record.update!(action_type: :new)
          cha_doctor_record.process_result(cha_doctor_record_hub)
          expect(cha_doctor_record.reload.state).to eq "unchecked"
        end
      end

      context "查询类型是refetch" do
        it "把所属报告更新为最新报告" do
          cha_doctor_record.update!(action_type: :refetch,
                                    cha_doctor_record_hub_id: 1,
                                    last_cha_doctor_record_hub_id: cha_doctor_record_hub.id)
          cha_doctor_record.process_result(cha_doctor_record_hub)
          expect(cha_doctor_record.reload.cha_doctor_record_hub_id).to eq cha_doctor_record_hub.id
          expect(cha_doctor_record.last_cha_doctor_record_hub_id).to eq cha_doctor_record_hub.id
          expect(cha_doctor_record.state).to eq "unchecked"
        end
      end
    end
  end
end
