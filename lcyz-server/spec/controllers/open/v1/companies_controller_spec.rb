require "rails_helper"

RSpec.describe Open::V1::CompaniesController do
  fixtures :all

  let(:tianche) { companies(:tianche) }

  before do
    access_app(tianche)
  end

  describe "GET /api/open/v1/company" do
    it "获取公司信息" do
      open_get :show

      expect(response_json[:data][:id]).to eq tianche.id
      expect(response_json[:meta][:version_catagory][:name]).to eq "车来客"
    end
  end

  describe "GET /api/open/v1/banners" do
    it "return banners for company" do
      open_get :banners

      banners = %w(http://google.com/image/1 http://google.com/image/2)
      expect(response_json[:data]).to eq banners
    end
  end

  describe "GET /api/open/v1/qrcode" do
    it "return the qrcode for company" do
      open_get :qrcode

      expect(response_json[:data]).to eq "http://google.com"
    end
  end
end
