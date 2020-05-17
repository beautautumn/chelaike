require "rails_helper"

RSpec.describe Open::V2::UsersController do
  fixtures :all

  let(:tianche) { companies(:tianche) }
  let(:zhangsan) { users(:zhangsan) }

  before do
    access_app(tianche)
  end

  describe "GET /api/open/v1/users/:id" do
    it "shows user" do
      open_get :show, id: zhangsan.id

      expect(response_json[:data][:id]).to eq zhangsan.id
    end
  end
end
