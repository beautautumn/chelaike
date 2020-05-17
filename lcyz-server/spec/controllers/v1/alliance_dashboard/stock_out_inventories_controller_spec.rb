require "rails_helper"

RSpec.describe V1::AllianceDashboard::StockOutInventoriesController do
  fixtures :all

  let(:alliance_zhangsan) { alliance_company_users(:alliance_zhangsan) }
  let(:alliance_lisi) { alliance_company_users(:alliance_lisi) }
  let(:alliance_tianche) { alliance_company_companies(:alliance_tianche) }
  let(:chuche) { alliances(:chuche) }

  let(:tianche) { companies(:tianche) }
  let(:aodi) { cars(:aodi) }

  before do
    chuche.add_company(tianche, "天车")
    aodi.update_columns(reserved_at: Time.zone.now, reserved: true)
    login_user(alliance_zhangsan)
  end

  describe "GET show" do
    it "返回出库车辆详情" do
      auth_get :show, car_id: aodi.id

      expect(response_json[:data][:id]).to eq aodi.stock_out_inventory.id
    end
  end
end
