require "rails_helper"

RSpec.describe Open::DetectionController do
  fixtures :all
  let(:tianche) { companies(:tianche) }

  def car_params(attrs = {})
    {
      brand_name: "aodi",
      series_name: "A4",
      vin: "asdfdfsa",
      manufactured_at: Date.new(2013, 6, 2),
      mileage: 12,
      displacement: "国标2",
      licensed_at: Date.new(2015, 4, 3),
      exterior_color: "green",
      interior_color: "blue",
      online_price_wan: 11,
      alliance_minimun_price_wan: 10,
      allowed_mortgage: true,
      images_attributes: [{ url: "image-1" }, { url: "image-2" }],
      compulsory_insurance_end_at: Date.new(2017, 3, 4),
      annual_inspection_end_at: Date.new(2017, 5, 8)
    }.merge(attrs)
  end

  before do
    @detection_config = DetectionConfig.create(
      platform_name: "bihu",
      c_id: tianche.id
    )
  end

  describe "POST create" do
    before do
      give_authority(tianche.owner, "牌证信息录入")
    end

    it "创建入库车辆" do
      expect do
        post :create,
             key: @detection_config.key, c_code: @detection_config.c_code,
             shop_name: "壁虎测试",
             car: car_params, report: { url: "report-url" }
      end.to change { Car.count }.by 1
    end

    it "创建检测报告，跟车辆绑定" do
      expect do
        post :create,
             key: @detection_config.key, c_code: @detection_config.c_code,
             shop_name: "壁虎测试",
             car: car_params, report: { url: "report-url" }
      end.to change { DetectionReport.count }.by 1
    end
  end
end
