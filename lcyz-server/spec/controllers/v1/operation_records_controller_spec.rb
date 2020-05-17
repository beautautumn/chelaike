require "rails_helper"

RSpec.describe V1::OperationRecordsController do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }
  let(:aodi) { cars(:aodi) }
  let(:alliance_aodi_created_record) { operation_records(:alliance_aodi_created_record) }

  before do
    login_user(zhangsan)
  end

  describe "GET /api/v1/operation_records/:id/alliance_cars_created_statistic" do
    it "lists all cars" do
      auth_get :alliance_cars_created_statistic, id: alliance_aodi_created_record.id

      expect(response_json[:data]).to be_present
    end
  end
end
