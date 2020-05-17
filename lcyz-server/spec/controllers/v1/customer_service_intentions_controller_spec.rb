require "rails_helper"

RSpec.describe V1::CustomerServiceIntentionsController do
  fixtures :all
  let(:zhangsan) { users(:zhangsan) }
  let(:lisi) { users(:lisi) }

  let(:doraemon_seeking_aodi) { intentions(:doraemon_seeking_aodi) }

  before do
    login_user(zhangsan)
  end

  describe "GET /api/v1/customer_service_intentions" do
    it "list all intentions created by user" do
      auth_get :index

      expect(response_json[:data]).to be_present
    end
  end

  describe "DELETE /api/v1/customer_service_intentions/:id" do
    it "deletes the specify intention" do
      expect do
        auth_delete :destroy, id: doraemon_seeking_aodi.id
      end.to change { Intention.count }.by(-1)
    end
  end
end
