require "rails_helper"

RSpec.describe V1::AllianceDashboard::WarrantiesController, type: :controller do
  fixtures :all

  let(:tianche) { companies(:tianche) }
  let(:a_level) { warranties(:a_level) }
  let(:zhangsan) { users(:zhangsan) }

  let(:alliance_zhangsan) { alliance_company_users(:alliance_zhangsan) }

  before do
    login_user(alliance_zhangsan)
  end

  describe "GET index" do
    it "得到某个车商设置的质保等级" do
      auth_get :index, company_id: tianche

      result = {
        data: [
          {
            id: a_level.id,
            name: a_level.name,
            fee: 1_000_000,
            note: "abc",
            company_id: tianche.id,
            created_at: iso8601_format("2015-01-10")
          }
        ]
      }

      expect(response_json).to eq result
    end
  end
end
