require "rails_helper"

RSpec.describe V1::CooperationCompaniesController do
  fixtures :all
  let(:tianche) { companies(:tianche) }
  let(:zhangsan) { users(:zhangsan) }
  let(:tiantian_clean) { cooperation_companies(:tiantian_clean) }

  before do
    give_authority(zhangsan, "业务设置")
    give_authority(zhangsan, "合作信息查看")
    login_user(zhangsan)
  end

  describe "GET /api/v1/cooperation_companies" do
    it "returns all cooperation_companies for specify company" do
      auth_get :index

      result = {
        data: [
          {
            id: tiantian_clean.id,
            name: "天天保洁",
            company_id: tianche.id,
            created_at: iso8601_format("2015-01-10")
          }
        ]
      }

      expect(response_json).to eq result
    end
  end

  describe "POST /api/v1/cooperation_companies" do
    it "creates a cooperation_company" do
      travel_to Time.zone.parse("2015-01-10")

      auth_post :create,
                cooperation_company: {
                  name: "橡皮公司"
                }

      cooperation_company = CooperationCompany.find_by(name: "橡皮公司")

      result = {
        data: {
          id: cooperation_company.id,
          name: "橡皮公司",
          company_id: tianche.id,
          created_at: iso8601_format("2015-01-10")
        }
      }

      expect(response_json).to eq result
    end

    it_should_behave_like "permission check", "业务设置" do
      let(:request_query) do
        auth_post :create,
                  cooperation_company: {
                    name: "橡皮公司"
                  }
      end
    end
  end

  describe "PUT /api/v1/cooperation_companies/:id" do
    it "updates a cooperation_company" do
      auth_put :update, id: tiantian_clean.id,
                        cooperation_company: {
                          name: "橡皮公司"
                        }
      result = {
        data: {
          id: tiantian_clean.id,
          name: "橡皮公司",
          company_id: tianche.id,
          created_at: iso8601_format("2015-01-10")
        }
      }

      expect(response_json).to eq result
    end

    it_should_behave_like "permission check", "业务设置" do
      let(:request_query) do
        auth_put :update, id: tiantian_clean.id,
                          cooperation_company: {
                            name: "橡皮公司"
                          }
      end
    end
  end

  describe "DELETE /api/v1/cooperation_companies/:id" do
    it "deletes a cooperation_company" do
      auth_delete :destroy, id: tiantian_clean.id

      result = {
        data: {
          id: tiantian_clean.id,
          name: "天天保洁",
          company_id: tianche.id,
          created_at: iso8601_format("2015-01-10")
        }
      }

      expect(response_json).to eq result
    end

    it_should_behave_like "permission check", "业务设置" do
      let(:request_query) do
        auth_delete :destroy, id: tiantian_clean.id
      end
    end
  end
end
