require "rails_helper"

RSpec.describe V1::ServiceAppointmentsController do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }
  let(:aodi) { cars(:aodi) }

  before do
    login_user(zhangsan)
  end

  describe "GET /api/v1/service_appointments" do
    it "list all service appointments" do
      auth_get :index

      expect(response_json[:data][0]).to be_present
    end
  end
end
