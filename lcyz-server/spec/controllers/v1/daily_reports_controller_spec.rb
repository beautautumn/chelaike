require "rails_helper"

RSpec.describe V1::DailyReportsController do
  fixtures :all

  let(:tianche) { companies(:tianche) }
  let(:zhangsan) { users(:zhangsan) }
  let(:tianche_daily_report) { operation_records(:tianche_daily_report) }

  before do
    login_user(zhangsan)
  end

  describe "GET /api/v1/daily_reports/:id" do
    it "lists cars by ids" do
      auth_get :show, id: tianche_daily_report.id, type: "cars_sold_today"

      expect(response_json[:data]).to be_present
    end
  end
end
