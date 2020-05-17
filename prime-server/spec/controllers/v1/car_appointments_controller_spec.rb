require "rails_helper"

RSpec.describe V1::CarAppointmentsController do
  fixtures :all

  let(:tianche) { companies(:tianche) }
  let(:zhangsan) { users(:zhangsan) }
  let(:aodi) { cars(:aodi) }

  before do
    login_user(zhangsan)
  end

  describe "POST /api/v1/car_appointments" do
    it "creates a service appointments" do
      expect do
        post :create, company_id: tianche.id,
                      car_appointment: {
                        name: "马云",
                        phone: "110",
                        car_id: aodi.id,
                        seller_id: zhangsan.id
                      }
      end.to change { Intention.count }.by(1)
    end
  end
end
