# frozen_string_literal: true
require "rails_helper"

RSpec.describe Admin::CarConfigurationsController, type: :controller do
  before do
    login_tenant
  end

  describe "PATCH #car_configuration" do
    it "save or create setting" do
      patch :update, params: { car_configuration: { down_payments: 11.22 } }
      expect(response).to redirect_to(admin_tenant_car_configuration_path)
    end
  end
end
