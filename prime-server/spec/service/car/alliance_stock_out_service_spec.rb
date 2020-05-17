require "rails_helper"

RSpec.describe Car::AllianceStockOutService do
  fixtures :all

  let(:a4_old) { cars(:a4) }
  let(:a4) { cars(:a4_copied) }
  let(:aodi) { cars(:aodi) }
  let(:avengers) { alliances(:avengers) }
  let(:warner) { companies(:warner) }
  let(:tianche) { companies(:tianche) }
  let(:twitter) { shops(:twitter) }
  let(:zhangsan) { users(:zhangsan) }
  let(:nolan) { users(:nolan) }
  let(:a4_tianche_to_warner) { alliance_stock_out_inventories(:a4_tianche_to_warner) }
  let(:a4_copied_acquisition) { transfer_records(:a4_copied_acquisition) }

  describe "联盟出库" do
    let(:service) do
      Car::AllianceStockOutService.new(user: nolan,
                                       car: a4,
                                       params: {
                                         alliance_id: avengers.id,
                                         from_company_id: warner.id,
                                         to_company_id: tianche.id,
                                         to_shop_id: twitter.id,
                                         seller_id: nolan.id,
                                         closing_cost_wan: 18,
                                         deposit_wan: 0,
                                         remaining_money_wan: 18,
                                         completed_at:  Time.zone.today
                                       })
    end

    it "修改原车状态" do
      service.create
      expect(a4.reload.state).to eq "alliance_stocked_out"
      expect(a4.reload.closing_cost_wan).to eq 18
      expect(a4.reload.stock_out_at).to eq Time.zone.today
    end

    it "复制新车" do
      service.create
      expect(service.new_car).to be_present
      expect(service.new_car.acquisition_price_wan).to eq 18
      expect(service.new_car.company).to eq tianche
      expect(service.new_car.images.count).to eq a4.images.count
      expect(service.new_car.state).to eq "in_hall"
      expect(service.new_car.acquisition_type).to eq "alliance"
      expect(service.new_car.acquired_at.to_date).to eq Time.zone.today
    end

    it "选择入库分店" do
      service.create
      expect(service.new_car.shop).to eq twitter
      expect(service.new_car.acquisition_transfer.shop_id).to eq twitter.id
      expect(service.alliance_stock_out_inventory.to_shop_id).to eq twitter.id
    end

    it "复制收购记录" do
      service.create
      expect(service.new_car.acquisition_transfer).to be_present
    end
    it "创建清单" do
      service.create
      expect(service.alliance_stock_out_inventory).to be_present
      expect(service.alliance_stock_out_inventory.to_car_id).to eq service.new_car.id
    end

    it "创建操作记录" do
      service.create
      expect(a4.operation_records
                 .where(operation_record_type: "stock_out"))
        .to be_present
      expect(service.new_car.operation_records
                    .where(operation_record_type: "alliance_stock_in"))
        .to be_present
    end

    it "不能重复出库" do
      service.create
      service.create
      expect(service.valid?).to be_falsy
    end
  end

  describe "联盟退车" do
    let(:service) do
      Car::AllianceStockOutService.new(user: nolan,
                                       new_car: a4,
                                       params: {
                                         refunded_at: Time.zone.today,
                                         refunded_price_wan: 18
                                       })
    end

    it "更新出库清单" do
      service.update
      expect(service.alliance_stock_out_inventory.reload.refunded_at).to eq Time.zone.today
      expect(service.alliance_stock_out_inventory.reload.refunded_price_wan).to eq 18
      expect(service.alliance_stock_out_inventory.reload.current).to be_falsy
    end

    it "原车回库" do
      service.update
      expect(a4_old.reload.state).to eq "in_hall"
      expect(a4_old.reload.closing_cost_wan).to be_nil
    end

    it "新车退库" do
      service.update
      expect(a4.reload.state).to eq "alliance_refunded"
    end

    it "创建操作记录" do
      service.update
      expect(a4.operation_records
                 .where(operation_record_type: "stock_out"))
        .to be_present
    end

    it "不能重复退车" do
      service.update
      service.update
      expect(service.valid?).to be_falsy
    end

    it "拒绝非法请求" do
      invalid_service = Car::AllianceStockOutService.new(user: nolan,
                                                         new_car: aodi,
                                                         params: {
                                                           refunded_at: Time.zone.today,
                                                           refunded_price_wan: 18
                                                         }).update
      expect(invalid_service.valid?).to be_falsy
    end
  end
end
