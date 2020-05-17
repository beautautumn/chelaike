require "rails_helper"

RSpec.describe Open::V3::ShopsController do
  fixtures :all
  let(:tianche) { companies(:tianche) }
  let(:warner) { companies(:warner) }
  let(:aodi) { cars(:aodi) }
  let(:a4_old) { cars(:a4) }

  describe "GET index" do
    it "得到所有车辆列表" do
      cherongyi_auth_get :index
      expect(response_json[:data].count).to be_present
    end
  end

  describe "GET all_cars" do
    before do
      [aodi, a4_old].map { |car| car.update!(company_id: tianche.id) }
    end

    it "根据传入的company_ids得到对应车商的所有车辆" do
      allow_any_instance_of(Car::WeshopService).to receive(:official_company_domain).and_return("company_domain")
      cherongyi_auth_get :all_cars, company_ids: [tianche.id, warner.id]
      expect(response_json).to be_present
    end
  end

  describe "GET shops_by_company" do
    it "根据车商ID得到它里面所有的分店信息" do
      cherongyi_auth_get :shops_by_company, id: tianche.id
      expect(response_json).to be_present
    end
  end

  describe "PUT update_accredited" do
    it "更新车商公司授信状态为已授信" do
      cherongyi_auth_put :update_accredited, id: tianche.id
      expect(tianche.reload.accredited).to be_truthy
    end
  end
end
