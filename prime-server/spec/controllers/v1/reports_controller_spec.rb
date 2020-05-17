require "rails_helper"

RSpec.describe V1::ReportsController do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }
  before do
    login_user(zhangsan)
  end

  describe "POST /api/v1/reports" do
    it "generates a xls file" do
      get :new, report_type: :cars_in_stock, "AutobotsToken" => zhangsan.token

      expect(response.status).to eq 200
    end
  end
end
