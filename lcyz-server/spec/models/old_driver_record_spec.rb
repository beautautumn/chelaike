require "rails_helper"

RSpec.describe OldDriverRecord, type: :model do
  fixtures :all

  let(:old_driver_record_hub) { old_driver_record_hubs(:old_driver_record_hub) }
  let(:old_driver_record) { old_driver_records(:old_driver_record_uncheck) }

  describe "#record_hub" do
    context "记录状态为更新" do
      it "使用之前的hub记录" do
        new_hub = OldDriverRecordHub.create!(order_id: 1234, vin: "asdf")
        old_driver_record.update!(
          before_update_hub_id: old_driver_record_hub.id,
          old_driver_record_hub_id: new_hub.id,
          state: :updating
        )

        expect(old_driver_record.record_hub).to eq old_driver_record_hub
      end
    end

    context "新记录" do
    end
  end
end
