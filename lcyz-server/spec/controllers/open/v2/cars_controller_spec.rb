require "rails_helper"

RSpec.describe Open::V2::CarsController do
  fixtures :all

  let(:tianche) { companies(:tianche) }
  let(:aodi) { cars(:aodi) }
  let(:avengers) { alliances(:avengers) }
  let(:warner) { companies(:warner) }
  let(:github) { companies(:github) }
  let(:nolan) { users(:nolan) }
  let(:old_driver_record_hub) { old_driver_record_hubs(:old_driver_record_hub) }

  before do
    access_app(tianche)
  end

  describe "GET /api/open/v2/cars" do
    it "获取联盟车辆列表" do
      open_get :index
      expect(response_json.size).to be > 0
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
      expect(Car.find(response_json[:data].last).show_price_wan).to be_nil
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

      open_get :fetch_by_ids, ids: aodi.id

      expect(response_json[:data][0][:id]).to eq aodi.id
      expect(response_json[:data][0][:presell]).to be_falsy
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

  describe "GET /api/open/v1/cars/:car_id/similar" do
    it "lists similar cars" do
      companies = [tianche, warner, github]
      avengers.add_companies(companies)
      companies.map { |c| c.update(open_alliance_id: avengers.id) }

      open_get :similar, car_id: aodi.id, per_page: 4

      expect(response.status).to eq 200
    end
  end

  describe "GET insurance_record" do
    it "得到某辆车的保险查询报告" do
      old_driver_record_hub.update!(vin: aodi.vin)
      open_get :insurance_record, car_id: aodi.id

      expect(response_json).to be_present
    end

    it "如果没有内容，返回空内容" do
      old_driver_record_hub.update!(vin: nil)
      open_get :insurance_record, car_id: aodi.id

      expect(response_json).to be_present
    end
  end

  describe "GET detection_report" do
    it "得到某辆车的检测报告" do
      aodi.create_detection_report!(
        report_type: :report,
        url: "report-url",
        platform_name: "bihu"
      )
      open_get :detection_report, car_id: aodi.id

      expect(response_json).to be_present
    end
  end

  describe "PUT update" do
    it "正常修改车辆是否可售值" do
      aodi.update!(sellable: true)
      open_put :update, id: aodi.id, car: { sellable: false, vin: "aaaaaaa" }
      expect(aodi.reload.sellable).to be_falsy
    end
  end
end
