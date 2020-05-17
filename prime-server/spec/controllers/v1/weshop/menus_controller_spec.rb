require "rails_helper"

RSpec.describe V1::Weshop::MenusController do
  fixtures :all
  let(:zhangsan) { users(:zhangsan) }
  let(:chelaike_mp) { wechat_apps(:chelaike_mp) }

  before do
    give_authority(zhangsan, "微店管理权限")
    login_user(zhangsan)

    travel_to Time.zone.parse("2015-01-01")
  end

  describe "GET /api/v1/weshop/menus" do
    it "shows info for menus" do
      auth_get :show
      expect(response_json[:data][:menus]).to eq chelaike_mp.menus.map(&:symbolize_keys)
    end
  end

  describe "PUT /api/v1/weshop/menus" do
    it "update wechat_app menus" do
      menus = [{ url: "http://cn.bing.com/", cate: "url", name: "链接", children: [] }]
      auth_put :update, menus: menus

      expect(response_json[:data][:menus]).to eq menus
    end
  end
end
