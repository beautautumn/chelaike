require "rails_helper"

RSpec.describe Market::CompaniesController do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }
  let(:tianche) { companies(:tianche) }

  before do
    login_user(zhangsan)
  end

  describe "PUT /api/v1/company" do
    it "updates erp infos" do
      auth_put :update, company: {
        erp_url: "http://abc.com",
        erp_id: 1
      }

      tianche.reload

      expect(tianche.erp_id).to eq "1"
      expect(tianche.erp_url).to eq "http://abc.com"
    end
  end

  describe "POST /api/v1/company/sync_cars" do
    it "starts a worker" do
      expect(MarketERPSyncWorker).to receive(:perform_async).with(tianche.id)

      auth_post :sync_cars
    end

    it "will be blocked" do
      auth_post :sync_cars
      auth_post :sync_cars

      expect(response_json[:message]).to eq "2分钟只能执行一次"
    end
  end
end
