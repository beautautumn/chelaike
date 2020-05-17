require "rails_helper"

RSpec.describe V1::ShopsController do
  fixtures :all

  let(:nolan) { users(:nolan) }

  before do
    give_authority(nolan, "业务设置")
    login_user(nolan)
  end

  describe "GET /api/v1/shops" do
    it "获取所有分店信息" do
      auth_get :index

      expect(response_json[:data].first[:company_id]).to eq nolan.company_id
    end
  end

  describe "POST /api/v1/shops" do
    it "创建分店" do
      shop_name = "microsoft"

      auth_post :create, shop: {
        name: shop_name,
        address: "地址",
        phone: "11112345678"
      }
      shop = Shop.find_by(name: shop_name)

      expect(response_json[:data][:id]).to eq shop.id
      expect(response_json[:data][:address]).to eq "地址"
      expect(shop.phone).to eq "11112345678"
    end
  end

  describe "PUT /api/v1/shops/:id" do
    it "更新分店" do
      shop = nolan.company.shops.first
      shop_name = "fuck disney"

      auth_put :update, id: shop.id, shop: {
        name: shop_name,
        address: "地址",
        phone: "11112345678"
      }

      expect(shop.reload.name).to eq shop_name
      expect(shop.address).to eq "地址"
      expect(shop.phone).to eq "11112345678"
    end
  end

  describe "DELETE /api/v1/shops/:id" do
    it "删除分店" do
      auth_delete :destroy, id: nolan.company.shops.first.id

      expect(nolan.company.shops).to be_empty
    end
  end
end
