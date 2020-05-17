require "rails_helper"

RSpec.describe RongMessageService do
  fixtures :all

  let(:create_aodi) { operation_records(:aodi_1_stock_out_sold_record) }
  let(:alliance_invitation) { operation_records(:alliance_invitation_record) }
  let(:daily_report) { operation_records(:tianche_daily_report) }
  let(:alliance_create_car) { operation_records(:alliance_aodi_created_record) }

  before do
    User.create!(id: -100, username: "statistics_messager", name: "统计消息",
                 phone: "statistics_messager", password: "e5f732bea0edc282fd9d")
    User.create!(id: -200, username: "stock_messager", name: "库存消息",
                 phone: "stock_messager", password: "463af81dca326aff30fb")
    User.create!(id: -300, username: "customer_messager", name: "客户消息",
                 phone: "customer_messager", password: "77e304e80b2078e488c7")
    User.create!(id: -400, username: "system_messager", name: "系统消息",
                 phone: "system_messager", password: "fa494f72fd883fb9c9cf")
  end

  describe "#publish" do
    it "能发送消息" do
      to_user_ids = [1, 2]
      VCR.use_cassette("rongcould/user", record: :new_episodes) do
        service = RongMessageService.new(daily_report, to_user_ids)
        result = service.publish
        expect(result[:code]).to eq 200
      end
    end

    context "类型是vin_image_request" do
      before do
        @xiaocheche = User.create!(
          name: "小车车",
          username: "小车车",
          phone: "xiaocheche",
          password: "xiaocheche",
          company_id: 1
        )

        @record = OperationRecord.create!(
          operation_record_type: :vin_image_request,
          user_id: @xiaocheche.id,
          shop_id: @xiaocheche.shop_id,
          company_id: @xiaocheche.company_id,
          messages: { car_id: 1,
                      cha_doctor_record_id: 23,
                      platform: :cha_doctor,
                      record_id: 23,
                      title: "VIN码识别",
                      car_name: "讴歌",
                      company_name: "天车测试" })
      end

      it "发送人应该是小车车账号" do
        service = RongMessageService.new(@record, [1])
        expect(service.instance_variable_get(:@from_user_id)).to eq @xiaocheche.id
      end

      it "生成特殊的content" do
        service = RongMessageService.new(@record, [1])
        content = service.send(:operation_record_content)
        expect(content[:content]).to be_present
      end
    end
  end
end
