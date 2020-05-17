require "rails_helper"

RSpec.describe Open::V1::ServiceAppointmentsController do
  fixtures :all

  let(:tianche) { companies(:tianche) }

  before do
    access_app(tianche)
  end

  describe "GET /api/open/v1/service_appointments/new" do
    it "creates a service appointments" do
      expect do
        open_get :new, service_appointment: {
          service_appointment_type: "vehicle_maintenance",
          customer_name: "马云",
          customer_phone: "110",
          note: "马老板的车子昨天被碰瓷了."
        }
      end.to change { ServiceAppointment.count }.by(1)
    end
  end
end
