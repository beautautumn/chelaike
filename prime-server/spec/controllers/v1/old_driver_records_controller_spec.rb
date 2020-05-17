require "rails_helper"

RSpec.describe V1::OldDriverRecordsController, type: :controller do
  fixtures :all
  let(:zhangsan) { users(:zhangsan) }
  let(:tianche) { companies(:tianche) }
  let(:vin) { "LJDGAA228E0410969" }
  let(:engine_num) { "E1022420" }
  let(:id_number) { "440105198803260025" }
  let(:aodi) { cars(:aodi) }

  let(:old_driver_record_hub) { old_driver_record_hubs(:old_driver_record_hub) }
  let(:old_driver_record) { old_driver_records(:old_driver_record_uncheck) }

  before do
    login_user zhangsan
    Token.create(company_id: zhangsan.company_id, balance: 200000)
  end

  describe "GET index" do
    it "得到这家公司里所有的查询记录" do
      auth_get :index

      expect(response_json).to be_present
    end
  end

  # 没有实现，不需要提供接口给外面使用
  describe "POST fetch" do
    it "可以购买报告" do
      auth_post :fetch, query: { vin: vin,
                                 engine_num: engine_num,
                                 id_number: id_number,
                                 license_no: "" }

      expect(response_json)
    end
  end

  describe "GET show" do
    it "得到某个报告的详情" do
      old_driver_record.update!(old_driver_record_hub_id: old_driver_record_hub.id)
      # old_driver_record_hub.update!(
      #   insurance: nil,
      #   claims: nil
      # )
      # old_driver_record.update!(old_driver_record_hub_id: old_driver_record_hub.id)

      auth_get :show, id: old_driver_record.id
      expect(response_json[:data]).to be_present
    end
  end

  describe "GET warehousing" do
    it "得到需要入库时的基本信息" do
      auth_get :warehousing, id: old_driver_record.id
      expect(response_json[:data][:vin]).to eq old_driver_record.vin
    end
  end

  describe "GET /api/v1/maintenance_records/detail" do
    before do
      give_authority(zhangsan, "维保详情查看")
    end

    it "returns 200" do
      old_driver_record.update!(car_id: aodi.id)
      auth_get :detail, query: { car_id: aodi.id }

      expect(response.status).to be 200
      expect(response_json).to be_present
    end
  end

  describe "GET share_record" do
    it "加密要分享的记录" do
      auth_get :share_record, id: old_driver_record.id
      expect(response_json[:data]).to be_present
    end
  end
end
