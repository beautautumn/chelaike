require "rails_helper"

RSpec.describe V1::Finance::CarIncomesController do
  fixtures :all
  let(:zhangsan) { users(:zhangsan) }
  let(:lisi) { users(:lisi) }
  let(:aodi_sold_income) { finance_car_incomes(:aodi_sold_income) }
  let(:tianche) { companies(:tianche) }
  let(:disney) { shops(:disney) }

  let(:individual) { channels(:individual) }
  let(:pingan) { insurance_companies(:pingan) }
  let(:cmb_china) { mortgage_companies(:cmb_china) }

  before do
    give_authority(zhangsan, "财务管理")
    login_user(zhangsan)
  end

  describe "GET /api/v1/finance/car_incomes" do
    it "gets all results" do
      auth_get :index
      expect(response_json[:data]).to be_present
    end

    it "gets search result" do
      auth_get :index, query: { car_name_cont: "Sport" }
      expect(response_json[:data].size).to eq 1
    end
  end

  describe "GET /api/v1/finance/car_incomes/export" do
    it "export search result" do
      auth_get :export
      expect(response.status).to be 200
    end
  end

  describe "GET /api/v1/finance/car_income/:id" do
    it "gets result" do
      auth_get :show, id: aodi_sold_income.id
      expect(response_json[:data]).to be_present
    end

    it "包含在库状态" do
      auth_get :show, id: aodi_sold_income.id
      expect(response_json[:data][:state]).to be_present
    end

    it "包含库存天数" do
      auth_get :show, id: aodi_sold_income.id
      expect(response_json[:data][:stock_age_days]).to be_present
    end
  end

  describe "PUT update_price" do
    context "修改入库价格" do
      it "可以修改价格" do
        auth_put :update_price, id: aodi_sold_income.id,
                                type: :in_stock,
                                finance_car_income: {
                                  shop_id: disney.id,
                                  acquirer_id: lisi.id,
                                  acquired_at: Date.new(2015, 9, 19),
                                  acquisition_price_wan: 20,
                                  note: "修改入库价格"
                                }

        expect(response_json[:data]).to be_present
        car = aodi_sold_income.reload.car
        expect(car.reload.acquisition_price_wan).to eq 20
        expect(aodi_sold_income.acquisition_price_wan).to eq 20
      end
    end

    context "修改出库价格"
    it "修改价格" do
      @stock_out_inventory = ParamsBuilder.build(
        :stock_out_inventories,
        zhangsan: zhangsan,
        individual: individual,
        pingan: pingan,
        cmb_china: cmb_china
      ).deep_symbolize_keys

      auth_put :update_price, id: aodi_sold_income.id,
                              type: :out_stock,
                              finance_car_income: {
                                closing_cost_wan: 35,
                                note: "价格更新啦"
                              },
                              stock_out_inventory: @stock_out_inventory.fetch(:mortgage)

      car = aodi_sold_income.car
      expect(car.stock_out_inventory.closing_cost_wan).to eq 35
      expect(response_json[:data]).to be_present
    end
  end

  describe "PUT /api/v1/finance/car_income/:id/update_fund_rate" do
    it "修改利率" do
      auth_put :update_fund_rate, id: aodi_sold_income.id,
                                  finance_car_income: {
                                    fund_rate: 3.0
                                  }

      expect(response_json[:data][:fund_rate]).to eq "3.0"
      expect(response_json[:data][:fund_cost_yuan]).to eq 1550
    end
  end
end
