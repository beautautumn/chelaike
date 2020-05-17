require "rails_helper"

RSpec.describe OldDriverService::API do
  let(:vin) { "LJDGAA228E0410969" }
  let(:engine_num) { "E1022420" }
  let(:id_number) { "440105198803260025" }

  describe "#buy_order" do
    before do
      travel_to Time.zone.parse("2017-03-08 17:57:30")
    end

    it "可以发送请求" do
      fetch = OldDriverService::API.new(
        vin: vin,
        engine_num: engine_num,
        id_number: id_number
      )

      VCR.use_cassette("old_driver/fetch") do
        fetch.buy_order
      end
    end
  end
end
