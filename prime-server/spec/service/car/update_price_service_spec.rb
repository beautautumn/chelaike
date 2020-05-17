require "rails_helper"

RSpec.describe Car::UpdatePriceService do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }
  let(:aodi) { cars(:aodi_sold) }
  let(:aodi_income) { finance_car_incomes(:aodi_sold_income) }
  let(:aodi_cash) { stock_out_inventories(:aodi_sold_cash) }

  let(:lisi) { users(:lisi) }
  let(:tianche) { companies(:tianche) }
  let(:disney) { shops(:disney) }

  let(:individual) { channels(:individual) }
  let(:pingan) { insurance_companies(:pingan) }
  let(:cmb_china) { mortgage_companies(:cmb_china) }

  before do
    give_authority(zhangsan, "财务管理")
    login_user(zhangsan)
  end

  describe "#in_stock" do
    let(:service) do
      Car::UpdatePriceService.new(zhangsan, aodi)
    end

    def in_stock_params
      {
        shop_id: disney.id,
        acquirer_id: lisi.id,
        acquired_at: Date.new(2015, 9, 21),
        acquisition_price_wan: 25,
        note: "修改入库价"
      }
    end

    it "修改车辆价格" do
      service.in_stock(in_stock_params)
      expect(aodi.reload.acquisition_price_wan).to eq 25
    end

    it "修改财务价格" do
      service.in_stock(in_stock_params)
      expect(aodi_income.reload.acquisition_price_wan).to eq 25
    end

    it "创建操作记录, 不发送消息" do
      expect { service.in_stock(in_stock_params) }.to change { OperationRecord.count }.by(1)
      expect { service.in_stock(in_stock_params) }.to change { Message.count }.by(0)
    end
  end

  describe "#out_stock" do
    let(:service) do
      Car::UpdatePriceService.new(zhangsan, aodi)
    end

    def out_stock_params
      {
        note: "价格更新啦",
        closing_cost_wan: "35"
      }
    end

    def stock_out_inventory_params
      stock_out_inventory = ParamsBuilder.build(
        :stock_out_inventories,
        zhangsan: zhangsan,
        individual: individual,
        pingan: pingan,
        cmb_china: cmb_china
      ).deep_symbolize_keys

      stock_out_inventory.fetch(:mortgage)
    end

    it "修改车辆价格" do
      service.out_stock(out_stock_params, stock_out_inventory_params)
      expect(aodi.reload.closing_cost_wan).to eq 35
    end

    it "修改财务价格" do
      service.out_stock(out_stock_params, stock_out_inventory_params)
      expect(aodi_income.reload.closing_cost_wan).to eq 35
    end

    it "创建操作记录" do
      expect do
        service.out_stock(out_stock_params, stock_out_inventory_params)
      end.to change { OperationRecord.count }.by(2)
    end
  end
end
