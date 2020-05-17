require "rails_helper"

RSpec.describe Intention::BatchAssignService::Manager do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }
  let(:lisi) { users(:lisi) }
  let(:doraemon_seeking_aodi) { intentions(:doraemon_seeking_aodi) }

  describe "#execute(assignee_id, processing_time)" do
    context "无下次跟进时间" do
      def operation
        service = Intention::BatchAssignService::Manager.new(zhangsan, [doraemon_seeking_aodi.id])
        service.execute(lisi.id)
      end

      it "把意向的指派人更改为新的assignee_id" do
        operation

        expect(doraemon_seeking_aodi.reload.assignee).to eq lisi
      end

      it "如果原来没有指派人，设置状态为pending" do
        doraemon_seeking_aodi.update(assignee_id: nil, state: "interviewed")
        operation

        expect(doraemon_seeking_aodi.reload.assignee).to eq lisi
        expect(doraemon_seeking_aodi.state).to eq "pending"
      end

      it "如果原来有指派人，意向状态不更改" do
        doraemon_seeking_aodi.update(assignee_id: lisi.id, state: "interviewed")
        operation

        expect(doraemon_seeking_aodi.reload.assignee).to eq lisi
        expect(doraemon_seeking_aodi.state).to eq "interviewed"
      end
    end

    context "有下次跟进时间" do
      def operation
        service = Intention::BatchAssignService::Manager.new(zhangsan, [doraemon_seeking_aodi.id])
        service.execute(lisi.id, 2.days.since)
      end

      it "增加一次意向跟进历史" do
        operation

        expect(doraemon_seeking_aodi.intention_push_histories.count).to eq 1
      end

      it "跟进结果为'继续跟进'" do
        operation

        expect(doraemon_seeking_aodi.reload.state).to eq "processing"
        expect(doraemon_seeking_aodi.latest_intention_push_history.state).to eq "processing"
      end

      it "下次跟进时间为指定的时间" do
        operation

        expect(doraemon_seeking_aodi.reload.processing_time).to eq 2.days.since.to_date
      end
    end
  end
end
