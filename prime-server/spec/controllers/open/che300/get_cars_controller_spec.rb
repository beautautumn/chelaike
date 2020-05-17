require "rails_helper"

RSpec.describe Open::Che300::GetCarsController do
  fixtures :all

  describe "GET /api/che300/get_cars" do
    it "return all cars after certain date" do
      get :index, app_id: ENV["CHE_300_GET_CARS_TOKEN"],
                  page_size: 5,
                  page_index: 1,
                  start_date: "2014-01-01"

      expect(response_json[:status_code]).to eq 0
    end

    it "return cars with page params" do
      get :index, app_id: ENV["CHE_300_GET_CARS_TOKEN"],
                  page_size: 3,
                  page_index: 2,
                  start_date: "2014-01-01"

      expect(response_json[:data][:items].count).to eq 3
    end

    it "return default page size if not set" do
      get :index, app_id: ENV["CHE_300_GET_CARS_TOKEN"]

      expect(response_json[:data][:page_size]).to eq 25
    end

    it "rejects wrong token" do
      get :index, app_id: "123456"
      expect(response_json[:status_code]).to eq(-1)
    end
  end
end
