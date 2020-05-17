require "rails_helper"

RSpec.describe Open::V3::CarsController do
  fixtures :all

  let(:aodi) { cars(:aodi) }

  describe "PUT update" do
    it "更改车辆借款状态" do
      cherongyi_auth_put :update, id: aodi.id, car: { loan_status: :loan }
      expect(aodi.reload.loan_status).to eq :loan
    end
  end
end
