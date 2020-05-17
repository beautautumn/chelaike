require "rails_helper"

RSpec.describe V1::IntentionLevelsController do
  fixtures :all

  let(:tianche) { companies(:tianche) }
  let(:intention_level_a) { intention_levels(:intention_level_a) }
  let(:zhangsan) { users(:zhangsan) }

  before do
    give_authority(zhangsan, "业务设置")
    login_user(zhangsan)
  end

  describe "GET /api/v1/intention_levels" do
    it "returns all intention_levels for specify" do
      auth_get :index

      result = {
        id: intention_level_a.id,
        name: "A级",
        note: nil,
        company_id: tianche.id,
        created_at: iso8601_format("2015-01-10"),
        time_limitation: 0,
        company_type: "Company"
      }

      expect(response_json[:data].last).to eq result
    end
  end

  describe "PUT /api/v1/intention_levels/:id" do
    it "updates specify intention_level" do
      auth_put :update, id: intention_level_a.id,
                        intention_level: { name: "C级" }

      result = {
        data: {
          id: intention_level_a.id,
          name: "C级",
          note: nil,
          company_id: tianche.id,
          created_at: iso8601_format("2015-01-10"),
          time_limitation: 0,
          company_type: "Company"
        }
      }

      expect(response_json).to eq result
    end

    it_should_behave_like "permission check", "业务设置" do
      let(:request_query) do
        auth_put :update, id: intention_level_a.id,
                          intention_level: { name: "C级" }
      end
    end
  end

  describe "POST /api/v1/intention_levels" do
    it "creates a intention_level" do
      travel_to Time.zone.parse("2015-01-10")

      auth_post :create,
                intention_level: {
                  name: "C级"
                }

      b_level = tianche.intention_levels.find_by(name: "C级")
      result = {
        data: {
          id: b_level.id,
          name: "C级",
          note: nil,
          company_id: tianche.id,
          created_at: iso8601_format("2015-01-10"),
          time_limitation: 0,
          company_type: "Company"
        }
      }

      expect(response_json).to eq result
    end

    it_should_behave_like "permission check", "业务设置" do
      let(:request_query) do
        auth_post :create, intention_level: { name: "A级" }
      end
    end
  end

  describe "DELETE /api/v1/intention_levels/:id" do
    it "deletes specify intention_level" do
      auth_delete :destroy, id: intention_level_a.id

      result = {
        data: {
          id: intention_level_a.id,
          name: intention_level_a.name,
          note: nil,
          company_id: tianche.id,
          created_at: iso8601_format("2015-01-10"),
          time_limitation: 0,
          company_type: "Company"
        }
      }

      expect(response_json).to eq result
    end

    it_should_behave_like "permission check", "业务设置" do
      let(:request_query) { auth_delete :destroy, id: intention_level_a.id }
    end
  end
end
