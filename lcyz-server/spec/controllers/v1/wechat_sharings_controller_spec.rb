require "rails_helper"

RSpec.describe V1::WechatSharingsController do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }
  let(:nolan) { users(:nolan) }
  let(:aodi) { cars(:aodi) }

  before do
    aodi.update_columns(reserved_at: nil, sellable: true)
  end

  describe "GET /api/v1/cars/:car_id/wechat_sharing/" do
    it "returns result" do
      get :show, car_id: aodi, seller_id: zhangsan.id
      data = response_json[:data]

      expect(data[:seller][:name]).to eq zhangsan.name
    end

    it "不带seller id" do
      get :show, car_id: aodi
      data = response_json[:data]

      expect(data[:company]).to be_present
    end
  end

  describe "GET /api/v1/cars/:car_id/wechat_sharing/allied_show" do
    it "联盟微信分享车辆信息" do
      login_user(nolan)

      get :allied_show, car_id: aodi, seller_id: nolan.id
      data = response_json[:data]

      expect(data[:company][:id]).to eq nolan.company_id
      expect(data[:seller][:name]).to eq nolan.name
    end
  end

  describe "GET /api/v1/cars/wechat_sharings" do
    it "通过 seller id 获取车辆列表" do
      get :index, seller_id: zhangsan.id
      data = response_json[:data]

      expect(data).to be_present
    end

    it "通过 company id 获取车辆列表" do
      get :index, company_id: zhangsan.company.id
      data = response_json[:data]

      expect(data).to be_present
    end

    it "根据品牌搜索" do
      get :index, seller_id: zhangsan.id, query: { brand_name_cont: "奥迪" }
      data = response_json[:data]

      expect(data.first[:name]).to include("奥迪")
    end

    it "根据价格搜索" do
      get :index, seller_id: zhangsan.id,
                  query: { online_price_wan_gt: 15, online_price_wan_lt: 25 }
      data = response_json[:data]

      data.each { |car| @searched_aodi = car if car[:id] == aodi.id }
      expect(@searched_aodi[:online_price_wan]).to be_within(5).of(20)
    end

    it "根据车龄搜索" do
      get :index, seller_id: zhangsan.id,
                  query: { age_gt: 0, agt_lt: 10 }
      data = response_json[:data]

      expect(data.first[:id]).to eq aodi.id
    end

    it "根据车辆类型搜索" do
      get :index, seller_id: zhangsan.id,
                  query: { car_type_eq: "suv" }
      data = response_json[:data]

      expect(data.first[:id]).to eq aodi.id
    end
  end
end
