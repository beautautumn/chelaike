require "rails_helper"

RSpec.describe V1::FunderCompaniesController do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }

  before do
    login_user(zhangsan)
  end

  describe "GET index" do
    it "得到所有的资金公司列表" do
      auth_get :index
      expect(response_json[:data]).to be_present
    end
  end
end
