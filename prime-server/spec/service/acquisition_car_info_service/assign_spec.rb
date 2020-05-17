require "rails_helper"

RSpec.describe AcquisitionCarInfoService::Assign do
  fixtures :all

  let(:tianche) { companies(:tianche) }
  let(:warner) { companies(:warner) }
  let(:disney) { shops(:disney) }
  let(:pixar) { shops(:pixar) }
  let(:zhangsan) { users(:zhangsan) }
  let(:lisi) { users(:lisi) }
  let(:aodi) { cars(:aodi) }
  let(:acquisition_aodi) { acquisition_car_infos(:aodi) }
  let(:avengers) { alliances(:avengers) }
  let(:zhangsan_tianche_sale_group) { conversations(:zhangsan_tianche_sale_group) }
  let(:tianche_sale) { chat_groups(:tianche_sale) }

  describe "#assign_to" do
    before do
      acquisition_aodi.update(acquirer_id: nil)
      @service = AcquisitionCarInfoService::Assign.new(zhangsan, acquisition_aodi)
    end

    it "把这条评估的收购人设置为指定的用户" do
      @service.assign_to(lisi.id)
      acquisition_aodi.reload
      expect(acquisition_aodi.acquirer_id).to eq lisi.id
      expect(acquisition_aodi.state).to eq "init"
    end

    it "创建操作记录，发送消息" do
      expect do
        @service.assign_to(lisi.id)
      end.to change { OperationRecord.count }.by(1)
    end
  end
end
