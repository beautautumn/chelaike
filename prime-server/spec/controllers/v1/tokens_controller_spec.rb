require "rails_helper"

RSpec.describe V1::TokensController do
  fixtures :users, :ant_queen_records, :ant_queen_record_hubs, :cars,
           :maintenance_settings, :companies, :tokens

  let(:zhangsan) { users(:zhangsan) }
  let(:ant_queen_record_uncheck) { ant_queen_records(:ant_queen_record_uncheck) }
  let(:company_token) { tokens(:company_token) }
  let(:user_token) { tokens(:user_token) }

  before do
    login_user(zhangsan)
    mock_prices
  end

  describe "#index" do
    before do
      company_token.update(balance: 10000)
    end

    it "returns 200" do
      auth_get :index

      expect(response.status).to eq 200
    end

    it "returns balance and price" do
      auth_get :index

      expect(response_json[:data][:balance]).to eq 10000
      expect(response_json[:data][:maintenance_record_price]).to eq MaintenanceRecord.unit_price
    end

    it "returns balance and ant_queen price" do
      VCR.use_cassette("ant_queen_buy_success", allow_playback_repeats: true) do
        auth_get :index, ant_queen_record_id: ant_queen_record_uncheck.id, platform_code: 1
        expect(response_json[:data][:ant_queen_record_price])
          .to eq AntQueenRecord.unit_price(
            car_brand_id: ant_queen_record_uncheck.car_brand_id,
            company: zhangsan.company
          )
      end
    end
  end

  describe "#new_index" do
    before do
      company_token.update(balance: 10000)
    end

    it "returns 200" do
      auth_get :new_index

      expect(response.status).to eq 200
    end

    it "returns balance and price" do
      auth_get :new_index

      expect(response_json[:data][:balance]).to eq 10000
      expect(response_json[:data][:maintenance_record_price]).to eq MaintenanceRecord.unit_price
    end

    it "returns balance and ant_queen price" do
      user_token.update!(balance: 100)
      company_token.update!(balance: 10)

      VCR.use_cassette("ant_queen_buy_success", allow_playback_repeats: true) do
        allow(DashenglaileRecord).to receive(:unit_price).and_return(15)
        auth_get :new_index, record_id: ant_queen_record_uncheck.id, platform_code: 1
        expect(response_json[:data][:ant_queen_record_price])
          .to eq AntQueenRecord.unit_price(
            car_brand_id: ant_queen_record_uncheck.car_brand_id,
            company: zhangsan.company
          )
      end
    end
  end

  describe "GET all" do
    it "得到这个员工个人及公司的车币数量" do
      auth_get :all

      return_json = {
        company_token: "100.23",
        user_token: "102.34"
      }

      expect(response_json[:data]).to eq return_json
    end
  end
end
