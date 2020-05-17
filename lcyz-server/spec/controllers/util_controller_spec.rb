require "rails_helper"

RSpec.describe UtilController do
  fixtures :all

  describe "GET /api/util/image_base64" do
    it "读取图片路径，base64编码图片内容" do
      VCR.use_cassette("img_base64") do
        get :image_base64,
            url: "http://tianche-playground.oss-cn-hangzhou.aliyuncs.com/123.jpg"

        expect(response_json[:data][:image_base64]).to be_present
      end
    end
  end

  describe "GET /api/util/ip_information" do
    before do
      allow_any_instance_of(
        ActionDispatch::Request
      ).to receive(:remote_ip).and_return("120.26.137.110")
    end

    it "返回IP信息" do
      VCR.use_cassette("ip_information") do
        get :ip_information

        expect(response_json[:data][:area]).to eq "华东"
      end
    end
  end

  # describe "GET /test" do
  #   it "返回 OK" do
  #     get :test
  #     expect(response.body).to eq "ok"
  #     expect(Rails.logger).not_to receive(:info).with(/test/)
  #   end
  # end
end
