require "rails_helper"

RSpec.describe Che3bao::CompaniesController do
  fixtures :all
  let(:tianche) { companies(:tianche) }

  describe "GET /api/param/corpInfo" do
    it "查询公司信息" do
      get :index, accessToken: tianche.md5_name

      expect(response_json[:data][:corpName]).to eq tianche.name
    end
  end
end
