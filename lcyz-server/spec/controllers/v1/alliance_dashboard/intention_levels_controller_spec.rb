require "rails_helper"

RSpec.describe V1::AllianceDashboard::IntentionLevelsController do
  fixtures :all

  let(:tianche) { companies(:tianche) }
  let(:intention_level_a) { intention_levels(:intention_level_a) }
  let(:zhangsan) { users(:zhangsan) }

  let(:alliance_zhangsan) { alliance_company_users(:alliance_zhangsan) }
  let(:alliance_tianche) { alliance_company_companies(:alliance_tianche) }
  let(:zhangsan) { users(:zhangsan) }
  let(:intention_level_a) { intention_levels(:intention_level_a) }
  let(:intention_level_b) { intention_levels(:intention_level_b) }

  before do
    login_user(alliance_zhangsan)
  end

  describe "GET index" do
    it "returns all intention_levels for specify" do
      auth_get :index, company_id: tianche.id

      result = {
        id: intention_level_a.id,
        name: "A级",
        note: nil,
        company_id: tianche.id,
        created_at: iso8601_format("2015-01-10"),
        time_limitation: 0
      }

      expect(response_json[:data].last).to eq result
    end
  end

  describe "Create alliance intention level" do
    it "create and return a new alliance intention_level" do
      # pending
      auth_post :create, intention_level: { name: "test_alliance_intention_level",
                                            time_limition: 0 }

      expect(response_json[:data][:name]).to eq "test_alliance_intention_level"
      expect(response_json[:data][:company_type]).to eq "AllianceCompany::Company"
    end
  end

  describe "Update an alliance intention level" do
    it "update and return intention level" do
      new_intention_level = IntentionLevel.create(name: "alliance_intention_level")
      auth_post :update, id: new_intention_level.id,
                         intention_level: { name: "updated_alliance_intention_level" }

      expect(response_json[:data][:name]).to eq "updated_alliance_intention_level"
    end
  end

  describe "Destroy alliance intention level" do
    it "destroy an alliance intention level" do
      new_intention_level = IntentionLevel.create(name: "alliance_intention_level")
      auth_delete :destroy, id: new_intention_level.id

      expect(IntentionLevel.find_by(id: new_intention_level.id)).to eq nil
    end
  end
end
