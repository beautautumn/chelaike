require "rails_helper"

RSpec.describe ChaDoctorService::GetReport do
  fixtures :users, :cars, :maintenance_settings, :companies

  let(:vin) { "LFPH3ACC7A1A61382" }
  let(:licenseplate) { "苏EX009K" }
  let(:order_id) { "e683890506454015a59533bf31f59773" }

  let(:zhangsan) { users(:zhangsan) }
  let(:aodi) { cars(:aodi) }
  let(:tumbler) { cars(:tumbler) }

  describe "#execute" do
    before do
      travel_to Time.zone.local(2016, 11, 4, 12, 30, 34)
      allow(SecureRandom).to receive(:uuid).and_return("8f643fe8-6b24-4213-86bb-6e6916327660")

      @hub = ChaDoctorRecordHub.create(vin: vin, order_id: order_id, notify_status: :success)
      @record = ChaDoctorRecord.create(vin: vin, state: :generating,
                                       cha_doctor_record_hub_id: @hub.id,
                                       last_cha_doctor_record_hub_id: @hub.id
                                      )
    end

    context "得到报告内容" do
      it "更新hub记录" do
        service = ChaDoctorService::GetReport.new(@hub)

        VCR.use_cassette("cha_doctors/get_report_json") do
          result = service.execute
          hub = result.hub
          expect(hub.fetch_info_at).to be_present
          expect(hub.report_details).to be_present
          expect(hub.brand_name).to be_present
        end
      end
    end

    context "返回结果有问题"
  end
end
