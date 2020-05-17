require "rails_helper"

RSpec.describe Company::DailyReminderService do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }
  let(:aodi) { cars(:aodi) }
  let(:tianche) { companies(:tianche) }
  let(:lisi) { users(:lisi) }
  let(:nolan) { users(:nolan) }
  let(:doraemon) { customers(:doraemon) }
  let(:doraemon_seeking_aodi) { intentions(:doraemon_seeking_aodi) }

  describe "#execute" do
    let(:service) do
      Company::DailyReminderService.new(tianche)
    end

    it "创建今日待跟进意向提醒" do
      expect { service.execute }.to change {
        OperationRecord.where(operation_record_type: :remind_intention_due).count
      }.by(2)

      expect(doraemon_seeking_aodi.operation_records
            .where(operation_record_type: :remind_intention_due)).to be_present
    end

    it "创建整备即将完成提醒" do
      expect { service.execute }.to change {
        OperationRecord.where(operation_record_type: :prepare_finish).count
      }.by(1)
    end

    it "创建库存预警提醒" do
      aodi.update_columns(stock_age_days: 30)
      expect { service.execute }.to change {
        OperationRecord.where(operation_record_type: :stock_warning).count
      }.by(1)
    end

    it "创建车辆今日到店提醒" do
      expect { service.execute }.to change {
        OperationRecord.where(operation_record_type: :remind_restock).count
      }.by(1)
    end
  end
end
