require "rails_helper"

RSpec.describe OperationRecord::MessageTextService do
  fixtures :all

  let(:aodi_created_record) { operation_records(:aodi_created_record) }

  describe "#execute" do
    context "with matched intentions" do
      before do
        aodi_created_record.update_columns(
          messages: aodi_created_record.messages.merge(
            matched_intentions: [1, 2],
            matched_intentions_count: 2
          ).deep_stringify_keys
        )
      end

      it "shows intentions count for message" do
        expected_result = "奥迪 A3 2014款 Sportback 35 TFSI 自动豪华型 匹配到 2 个意向"

        service = OperationRecord::MessageTextService.new(aodi_created_record)
        expect(service.execute).to eq expected_result
      end

      it "shows message for notification" do
        expected_result = "有客户想要的新车入库了哦! 奥迪 A3 2014款 Sportback 35 TFSI 自动豪华型 匹配到 2 个意向"

        service_for_notification = OperationRecord::MessageTextService.new(
          aodi_created_record, notification_alert: true
        )
        expect(service_for_notification.execute).to eq expected_result
      end
    end

    context "notification alert" do
      it "shows normal message if no intentions matched" do
        expected_result = "车辆入库: Zhangsan 完成奥迪 A3 2014款 Sportback 35 TFSI 自动豪华型入库"

        service = OperationRecord::MessageTextService.new(aodi_created_record)
        service_for_notification = OperationRecord::MessageTextService.new(
          aodi_created_record, notification_alert: true
        )

        expect(service.execute).to eq expected_result
        expect(service_for_notification.execute).to eq expected_result
      end
    end
  end
end
