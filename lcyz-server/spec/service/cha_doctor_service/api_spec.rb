require "rails_helper"

RSpec.describe ChaDoctorService::API do
  fixtures :all
  let(:vin) { "LFPH3ACC7A1A61382" }
  let(:licenseplate) { "苏EX009K" }
  let(:order_id) { "e683890506454015a59533bf31f59773" }
  # let(:vin) { "asdfdfsa" }

  before do
    travel_to Time.zone.local(2016, 11, 4, 12, 30, 34)
    allow(SecureRandom).to receive(:uuid).and_return("8f643fe8-6b24-4213-86bb-6e6916327660")

    # WebMock.allow_net_connect!
    # VCR.turn_off!
  end

  describe ".check_brand(vin)" do
    it "检查一个vin码是否支持查询" do
      VCR.use_cassette("cha_doctors/check_brand") do
        result = ChaDoctorService::API.check_brand(vin)
        expect(result.status).to eq :success
      end
    end
  end

  describe ".buy_report(vin)" do
    it "购买一条报告" do
      VCR.use_cassette("cha_doctors/buy_report") do
        result = ChaDoctorService::API.buy_report(vin)
        expect(result.code).to eq "0"
        expect(result.data).to eq order_id
      end
    end
  end

  describe ".get_report_json(orderid)" do
    it "得到这个订单的具体详情" do
      VCR.use_cassette("cha_doctors/get_report_json") do
        result = ChaDoctorService::API.get_report_json(order_id)
        expect(result.data).to be_present
      end
    end
  end

  describe ".parse_summary_data" do
    it "解析页面上的事故分析，车况分析内容" do
      url = <<-URL.squish!
      http://api.chaboshi.cn/new_report/show_report?
      nonce=aeac1978-e6d1-49dd-9d28-e1ed6ae324d5&orderid=ca0de57a482f43bbb01568070a9147c1&
      signature=qvh5ROA1REfgZdl7MnuH8aRRQo0%3D
      &timestamp=1482825224975&userid=3376
      URL

      url = url.delete(" ")

      VCR.use_cassette("cha_doctors/parse_page") do
        result = ChaDoctorService::API.parse_summary_data(url)
        expect(result.data.fetch(:summany_status_data)).to be_present
      end
    end
  end
end
