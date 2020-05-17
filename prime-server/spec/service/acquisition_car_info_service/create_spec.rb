require "rails_helper"

RSpec.describe AcquisitionCarInfoService::Create do
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

  def acquisition_car_info_params
    acquisition_aodi.attributes.except!(
      "id", "acquirer_id", "state"
    )
  end

  describe "#execute" do
    it "创建一个收车信息" do
      service = AcquisitionCarInfoService::Create.new(
        zhangsan, acquisition_car_info_params
      )

      result = service.execute(
        chat_id: zhangsan_tianche_sale_group.id,
        chat_type: "group"
      )

      expect(result.info).to be_persisted
    end

    it "跟会话建立关系，记录在哪些会话里发送的这个消息" do
      service = AcquisitionCarInfoService::Create.new(
        zhangsan, acquisition_car_info_params.merge("owner_info" => {})
      )

      result = service.execute(
        chat_id: tianche_sale.id,
        chat_type: "group"
      )

      car_info = result.info
      record = car_info.publish_records.last
      expect(car_info.publish_records.count).to eq 1
      expect(record.chatable).to eq tianche_sale
    end
  end
end
