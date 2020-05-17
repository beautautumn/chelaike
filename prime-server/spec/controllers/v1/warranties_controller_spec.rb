require "rails_helper"

RSpec.describe V1::WarrantiesController do
  fixtures :all

  let(:tianche) { companies(:tianche) }
  let(:a_level) { warranties(:a_level) }
  let(:zhangsan) { users(:zhangsan) }

  before do
    give_authority(zhangsan, "业务设置")
    login_user(zhangsan)
  end

  describe "GET /api/v1/warranties" do
    it "returns all warranties for specify company" do
      auth_get :index

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

  describe "POST /api/v1/warranties" do
    it "creates a warranty" do
      travel_to Time.zone.parse("2015-01-10")

      auth_post :create,
                warranty: {
                  name: "B级别",
                  fee: 200,
                  note: "abc"
                }

      b_level = Warranty.find_by(name: "B级别")

      result = {
        data: {
          id: b_level.id,
          company_id: tianche.id,
          name: "B级别",
          fee: 200,
          note: "abc",
          created_at: iso8601_format("2015-01-10")
        }
      }

      expect(response_json).to eq result
    end

    it_should_behave_like "permission check", "业务设置" do
      let(:request_query) do
        auth_post :create,
                  warranty: {
                    name: "B级别",
                    fee: 200,
                    note: "abc"
                  }
      end
    end
  end

  describe "PUT /api/v1/:id" do
    it "updates a warranty" do
      auth_put :update, id: a_level.id,
                        warranty: {
                          name: "BBB",
                          note: "CCC"
                        }

      result = {
        data: {
          id: a_level.id,
          name: "BBB",
          fee: 1_000_000,
          note: "CCC",
          company_id: tianche.id,
          created_at: iso8601_format("2015-01-10")
        }
      }

      expect(response_json).to eq result
    end

    it_should_behave_like "permission check", "业务设置" do
      let(:request_query) do
        auth_put :update, id: a_level.id,
                          warranty: {
                            name: "BBB"
                          }
      end
    end
  end

  describe "DELETE /api/v1/:id" do
    it "deletes specify warranty" do
      auth_delete :destroy, id: a_level.id

      result = {
        data: {
          id: a_level.id,
          name: "一级",
          fee: 1_000_000,
          note: "abc",
          company_id: tianche.id,
          created_at: iso8601_format("2015-01-10")
        }
      }

      expect(response_json).to eq result
    end

    it_should_behave_like "permission check", "业务设置" do
      let(:request_query) { auth_delete :destroy, id: a_level.id }
    end
  end
end
