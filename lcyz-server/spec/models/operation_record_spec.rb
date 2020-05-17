# == Schema Information
#
# Table name: operation_records # 操作历史
#
#  id                    :integer          not null, primary key # 操作历史
#  targetable_id         :integer                                # 多态ID
#  targetable_type       :string                                 # 多态类型
#  operation_record_type :string                                 # 事件类型
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  user_id               :integer                                # 操作人ID
#  messages              :jsonb                                  # 操作信息
#  company_id            :integer                                # 公司ID
#  shop_id               :integer                                # 店ID
#  detail                :jsonb                                  # 详情
#  user_type             :string           default("User")
#  user_passport         :jsonb                                  # 操作用户信息
#

require "rails_helper"

RSpec.describe OperationRecord, type: :model do
  fixtures :all
  let(:aodi) { cars(:aodi) }
  let(:zhangsan) { users(:zhangsan) }
  let(:tianche) { companies(:tianche) }

  describe "message push worker" do
    it "will be executed" do
      expect(MessageWorker).to receive(:perform_in)

      OperationRecord.create(
        targetable_id: aodi.id,
        targetable_type: "Car",
        user_id: zhangsan.id,
        company_id: tianche.id,
        operation_record_type: "car_created",
        messages: {
          imported: false,
          title: "新车入库",
          stock_number: "abc",
          user_name: "Zhangsan",
          name: "奥迪 A3 2014款 Sportback 35 TFSI 自动豪华型",
          acquirer_name: "Zhangsan"
        }
      )
    end
  end

  describe "alliance message push worker" do
    it "will be executed" do
      expect(AllianceMessageWorker).to receive(:perform_in)

      OperationRecord.create(
        targetable_id: aodi.id,
        targetable_type: "AllianceInvitation",
        user_id: zhangsan.id,
        company_id: tianche.id,
        operation_record_type: "alliance_invitation_created",
        messages: {
          imported: false,
          title: "新车入库",
          stock_number: "abc",
          user_name: "Zhangsan",
          name: "奥迪 A3 2014款 Sportback 35 TFSI 自动豪华型",
          acquirer_name: "Zhangsan"
        }
      )
    end
  end

  describe "#message_type" do
    it "返回相应的消息类型" do
      record = OperationRecord.create(
        targetable_id: aodi.id,
        targetable_type: "AllianceInvitation",
        user_id: zhangsan.id,
        company_id: tianche.id,
        operation_record_type: "car_created",
        messages: {
          imported: false,
          title: "新车入库",
          stock_number: "abc",
          user_name: "Zhangsan",
          name: "奥迪 A3 2014款 Sportback 35 TFSI 自动豪华型",
          acquirer_name: "Zhangsan"
        }
      )

      expect(record.message_type).to eq :stock
    end
  end
end
