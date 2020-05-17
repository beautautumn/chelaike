require "rails_helper"

RSpec.describe V1::ImportTasksController do
  fixtures :all
  let(:zhangsan) { users(:zhangsan) }

  before do
    login_user(zhangsan)
  end

  describe "GET /api/v1/import_tasks" do
    it "list all import task records" do
      auth_get :index

      expect(response_json[:data]).to be_present
    end
  end
end
