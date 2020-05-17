require "rails_helper"

RSpec.describe Open::V1::CarsController do
  fixtures :all

  let(:tianche) { companies(:tianche) }
  let(:aodi) { cars(:aodi) }
  let(:avengers) { alliances(:avengers) }
  let(:warner) { companies(:warner) }
  let(:github) { companies(:github) }
  let(:nolan) { users(:nolan) }

  before do
    access_app(tianche)
  end

  describe "GET /api/open/v1/cars" do
    it "获取联盟车辆列表" do
      open_get :index

      expect(response_json[:data].size).to be > 0
    end

    it "联盟车辆只获取自家车辆列表" do
      open_get :index, without_allied: true

      company_ids = response_json[:data].collect { |car| car[:company_id] }.uniq

      expect(company_ids.size).to eq 1
      expect(company_ids.first).to eq tianche.id
    end

    it "获取在库车辆列表" do
      tianche.update_column(:open_alliance_id, nil)
      open_get :index

      expect(response_json[:data].size).to be > 0
    end

    it "获取在库车辆列表, 并且无图无价格的对象排后" do
      tianche.update_column(:open_alliance_id, nil)
      tianche.cars.first.update_column(:show_price_cents, nil)
      open_get :index, available_first: true, per_page: tianche.cars.count

      expect(response_json[:data].size).to be > 0
      expect(response_json[:data].last[:show_price_wan]).to be_nil
    end

    it "获取车辆详情" do
      alliance = alliances(:chuche)
      alliance_tianche = alliance_company_companies(:alliance_tianche)

      alliance.add_company(tianche)
      alliance.update(alliance_company: alliance_tianche)
      alliance_tianche.add_company(tianche)
      alliance_tianche.update(
        water_mark: "http://aliyun.com/aaa.jpg",
        water_mark_position: { p: 1, x: 10, y: 20 }
      )

      open_get :show, id: aodi.id

      expect(response_json[:data][:id]).to eq aodi.id
      expect(response_json[:data][:presell]).to be_falsy
    end
  end

  describe "POST /api/open/v1/cars/:car_id/subscribe" do
    it "creates a record" do
      expect do
        open_get :subscribe, car_id: aodi.id, seller_id: nolan.id,
                             buyer_appointment: {
                               customer_name: "张三",
                               customer_phone: "110"
                             }
      end.to change { nolan.company.intentions.count }.by(1)
    end
  end

  describe "GET /api/open/v1/cars/:car_id/price_similar" do
    it "lists similar cars on price" do
      open_get :price_similar, car_id: aodi.id, per_page: 4

      result_prices = response_json[:data].map { |a| a[:online_price_wan] }
      expect(result_prices).to eq [19, 19, 18, 20]
    end
  end

  describe "GET /api/open/v1/cars/:car_id/similar" do
    it "lists similar cars" do
      companies = [tianche, warner, github]
      avengers.add_companies(companies)
      companies.map { |c| c.update(open_alliance_id: avengers.id) }

      open_get :similar, car_id: aodi.id, per_page: 4

      expect(response.status).to eq 200
    end
  end
end
