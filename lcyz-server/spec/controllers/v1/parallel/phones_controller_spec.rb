require "rails_helper"

RSpec.describe V1::Parallel::PhonesController, type: :controller do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }
  let(:service) { parallel_phones(:service) }

  before do
    login_user(zhangsan)
  end

  describe "GET #show" do
    it "returns result" do
      auth_get :show
      expect(response_json[:data][:number]).to eq service.number
    end
  end
end
