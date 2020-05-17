require "rails_helper"

RSpec.describe V1::ChaDoctorRecordsController do
  fixtures :all

  let(:vin) { "LFPH3ACC7A1A61382" }
  let(:licenseplate) { "苏EX009K" }

  let(:zhangsan) { users(:zhangsan) }
  let(:lisi) { users(:lisi) }
  # let(:ant_queen_record_uncheck) { ant_queen_records(:ant_queen_record_uncheck) }
  let(:cha_doctor_record_hub) { cha_doctor_record_hubs(:cha_doctor_record_hub) }
  let(:cha_doctor_record) { cha_doctor_records(:cha_doctor_record_uncheck) }
  let(:records) { AntQueenRecord.all }
  let(:aodi) { cars(:aodi) }
  let(:tumbler) { cars(:tumbler) }

  before do
    give_authority(zhangsan, "维保详情查看", "维保报告查询")
    login_user(zhangsan)

    travel_to Time.zone.local(2016, 11, 4, 12, 30, 34)
    allow(SecureRandom).to receive(:uuid).and_return("8f643fe8-6b24-4213-86bb-6e6916327660")

    Token.create(company_id: zhangsan.company_id, balance: 200000)
  end

  describe "GET index" do
    it "列出所有查博士查询记录" do
      auth_get :index

      expect(response_json).to be_present
    end
  end

  describe "GET show" do
    it "得以报告详情" do
      aodi.update(vin: vin)
      cha_doctor_record.update(cha_doctor_record_hub: cha_doctor_record_hub)
      auth_get :show, id: cha_doctor_record.id

      expect(response_json).to be_present
    end

    it "查询记录状态更新为checked"
  end

  describe "POST fetch" do
    it "可以购买报告" do
      TokenBill.destroy_all
      ChaDoctorRecordHub.destroy_all
      Token.create(company_id: zhangsan.company_id, balance: 200000)
      VCR.use_cassette("cha_doctors/fetch") do
        expect do
          auth_post :fetch, query: { vin: vin }
        end.to change { ChaDoctorRecordHub.count }.by(1).and\
          change { TokenBill.count }.by(1)
      end
    end
  end

  describe "POST refetch" do
    before do
      cha_doctor_record.update!(user_id: lisi.id, user_name: lisi.name)
    end

    it "生成一条新的查询记录" do
      VCR.use_cassette("cha_doctors/fetch") do
        expect do
          auth_post :refetch, id: cha_doctor_record.id
        end.to change { ChaDoctorRecord.count }.by(1)
      end
    end

    it "更新这条查询记录对应的报告" do
      VCR.use_cassette("cha_doctors/fetch") do
        expect do
          auth_post :refetch, id: cha_doctor_record.id
        end.to change { ChaDoctorRecordHub.count }.by(1)

        hub = ChaDoctorRecordHub.last
        expect(cha_doctor_record.reload.last_cha_doctor_record_hub).to eq hub
      end
    end
  end

  describe "GET warehousing" do
    it "得到需要入库时的基本信息" do
      auth_get :warehousing, id: cha_doctor_record.id
      expect(response_json[:data][:vin]).to eq cha_doctor_record.vin
    end
  end
end
