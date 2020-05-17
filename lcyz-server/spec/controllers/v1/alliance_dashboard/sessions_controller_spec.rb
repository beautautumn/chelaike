require "rails_helper"

RSpec.describe V1::AllianceDashboard::SessionsController do
  fixtures :all

  let(:alliance_zhangsan) { alliance_company_users(:alliance_zhangsan) }
  let(:alliance_tianche) { alliance_company_companies(:alliance_tianche) }
  let(:zhangsan) { users(:zhangsan) }
  let(:tianche) { users(:tianche) }

  describe "#login" do
    context "user in the alliance_company" do
      it "can log in" do
        post :create, user: { login: "alliance_zhangsan", password: "ZhangSan" }

        response_data = response_json[:data]
        expect(response.status).to eq 200
        expect(assigns[:current_user]).to eq alliance_zhangsan
        expect(response_data).to have_key(:token)
        expect(response_data).to have_key(:alliance_company)
      end
    end

    context "user not in the league_company" do
      it "refuses the user to log in" do
        post :create, user: { login: "zhangsan", password: "ZhangSan" }

        expect(response.status).to eq 401
      end
    end
  end
end
