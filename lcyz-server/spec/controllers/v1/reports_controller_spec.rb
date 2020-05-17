require "rails_helper"

RSpec.describe V1::ReportsController do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }
  let(:doraemon) { customers(:doraemon) }
  let(:aodi) { cars(:aodi) }
  let(:a4_old) { cars(:a4) }
  let(:aodi_cash) { stock_out_inventories(:aodi_cash) }
  let(:pixar) { shops(:pixar) }

  before do
    give_authority(zhangsan, "库存明细导出", "客户明细导出", "销售明细导出")
    login_user(zhangsan)
  end

  describe "POST /api/v1/reports" do
    it "generates a xls file" do
      get :new, report_type: :cars_in_stock, "AutobotsToken" => zhangsan.token

      expect(response.status).to eq 200
    end
  end

  describe "GET /api/v1/reports" do
    context "报表类型是车辆" do
      it "得到相应数据" do
        auth_get :index, report_type: :bm_cars
        expect(response_json[:data]).to be_present
      end

      it "过滤参数" do
        auth_get :index,
                 report_type: :bm_cars,
                 query: { shop_city_eq: "杭州市" }
        expect(response_json[:data]).to be_present
      end
    end

    context "报表类型是销售数据" do
      it "得到相应数据" do
        aodi.update!(shop: pixar)
        StockOutInventory.update_all(
          car_id: aodi, customer_id: doraemon.id
        )
        auth_get :index, report_type: :bm_sold_out
        expect(response_json[:data]).to be_present
      end

      it "过滤参数" do
        aodi.update!(shop: pixar)
        auth_get :index,
                 report_type: :bm_sold_out,
                 query: { car_owner_company_id_eq: pixar.id }
        expect(response_json[:data]).to be_present
      end
    end

    context "报表类型是用户意向" do
      it "得到相应数据" do
        Intention.update_all(state: :pending)
        auth_get :index, report_type: :bm_intention
        expect(response_json[:data]).to be_present
      end

      it "过滤参数" do
        aodi.update!(shop: pixar)
        auth_get :index,
                 report_type: :bm_sold_out,
                 query: { car_owner_company_id_eq: pixar.id }
        expect(response_json[:data]).to be_present
      end
    end
  end
end
