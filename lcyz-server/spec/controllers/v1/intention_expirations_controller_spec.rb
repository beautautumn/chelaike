require "rails_helper"

RSpec.describe V1::IntentionExpirationsController, type: :controller do
  fixtures :all

  let(:tianche) { companies(:tianche) }
  let(:intention_expiration_tianche) { intention_expirations(:intention_expiration_tianche) }
  let(:zhangsan) { users(:zhangsan) }
  let(:git) { users(:git) }

  before do
    give_authority(zhangsan, "业务设置")
    login_user(zhangsan)
  end

  describe "GET /api/v1/intention_expiration" do
    it "return data" do
      auth_get :show
      expect(response_json[:data][:recovery_time])
        .to eq intention_expiration_tianche.recovery_time
      expect(response_json[:data][:recovery_hour])
        .to eq intention_expiration_tianche.recovery_hour
    end

    it "return empty when expiration not set" do
      login_user(git)
      auth_get :show
      expect(response_json[:data]).to be_empty
    end
  end

  describe "PUT /api/v1/intention_expiration" do
    it "updates specify intention_expiration" do
      auth_put :update, intention_expiration: { recovery_time: "7" }
      expect(response_json[:data][:recovery_time]).to eq 7
      expect(response_json[:data][:recovery_hour]).to eq 7
    end

    it "rejects illegal intention_expiration" do
      auth_put :update, intention_expiration: { recovery_time: "asd", recovery_hour: "asdf" }
      expect(response_json[:errors]).to be_present
    end

    it "creates expiration if not set" do
      login_user(git)
      give_authority(git, "业务设置")

      auth_put :update, intention_expiration: { recovery_time: "7" }
      expect(response_json[:data][:recovery_time]).to eq 7
      expect(response_json[:data][:company_id]).to eq git.company.id
      expect(git.company.intention_expiration.recovery_time).to eq 7
    end

    it "deletes expiration when time is empty" do
      auth_put :update
      expect(response_json[:data]).to be_empty
      expect(tianche.intention_expiration).to be_blank
    end

    it_should_behave_like "permission check", "业务设置" do
      let(:request_query) do
        auth_put :update, intention_expiration: { recovery_time: "7" }
      end
    end
  end
end
