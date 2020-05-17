require "rails_helper"

RSpec.describe V1::AllianceStockOutInventoriesController do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }
  let(:lisi) { users(:lisi) }
  let(:nolan) { users(:nolan) }
  let(:avengers) { alliances(:avengers) }
  let(:warner) { companies(:warner) }
  let(:tianche) { companies(:tianche) }
  let(:twitter) { shops(:twitter) }
  let(:a4_old) { cars(:a4) }
  let(:a4) { cars(:a4_copied) }
  let(:aodi) { cars(:aodi) }

  describe "GET /api/v1/cars/:car_id/stock_out_inventory" do
    it "有'收购价格查看'权限, 可以查看联盟出库信息(微合同)" do
      give_authority(lisi, "收购价格查看")
      login_user(lisi)
      auth_get :show, car_id: a4_old.id

      expect(response_json[:data]).to be_present
    end

    it "没有权限无法查看" do
      deprive_authority(lisi, "收购价格查看")
      login_user(lisi)
      auth_get :show, car_id: a4_old.id

      expect(response_json[:data]).to be_nil
    end

    it "可以查看自己的微合同" do
      deprive_authority(zhangsan, "收购价格查看")
      login_user(zhangsan)
      auth_get :show, car_id: a4_old.id

      expect(response_json[:data]).to be_present
    end
  end

  describe "POST /api/v1/cars/:car_id/stock_out_inventories" do
    it "创建出库清单" do
      give_authority(zhangsan, "在库车辆出库")
      login_user(zhangsan)
      auth_post :create, car_id: a4.id,
                         alliance_stock_out_inventory: {
                           alliance_id: avengers.id,
                           to_company_id: tianche.id,
                           to_shop_id: twitter.id,
                           seller_id: nolan.id,
                           closing_cost_wan: 18,
                           deposit_wan: 0,
                           remaining_money_wan: 18,
                           completed_at:  Time.zone.today
                         }
      expect(response_json[:data]).to be_present
    end

    it "拒绝不完整参数" do
      give_authority(zhangsan, "在库车辆出库")
      login_user(zhangsan)
      auth_post :create, car_id: a4.id,
                         alliance_stock_out_inventory: {
                           alliance_id: avengers.id,
                           to_company_id: tianche.id,
                           # to_shop_id: twitter.id,
                           seller_id: nolan.id,
                           closing_cost_wan: 18,
                           # deposit_wan: 0,
                           # remaining_money_wan: 18,
                           completed_at:  Time.zone.today
                         }
      expect(response_json[:errors]).to be_present
    end
  end

  describe "PUT /api/v1/cars/:car_id/stock_out_inventory" do
    it "创建退库记录" do
      give_authority(nolan, "在库车辆出库")
      login_user(nolan)
      auth_put :update, car_id: a4.id,
                        alliance_stock_out_inventory: {
                          refunded_price_wan: 18,
                          refunded_at: Time.zone.today
                        }
      expect(response_json[:data]).to be_present
    end

    it "拒绝非法请求" do
      give_authority(nolan, "在库车辆出库")
      login_user(nolan)
      auth_put :update, car_id: aodi.id,
                        alliance_stock_out_inventory: {
                          refunded_price_wan: 18,
                          refunded_at: Time.zone.today
                        }
      expect(response_json[:errors]).to be_present
    end
  end
end
