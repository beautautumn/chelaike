require "rails_helper"

RSpec.describe V1::InsuranceCompaniesController do
  fixtures :all

  let(:tianche) { companies(:tianche) }
  let(:pingan) { insurance_companies(:pingan) }
  let(:zhangsan) { users(:zhangsan) }

  before do
    give_authority(zhangsan, "业务设置")
    login_user(zhangsan)
  end

  describe "GET /api/v1/insurance_companies" do
    it "returns all insurance_companies for specify" do
      auth_get :index

      result = {
        data: [
          {
            id: pingan.id,
            name: "平安保险",
            company_id: tianche.id,
            created_at: iso8601_format("2015-01-10")
          }
        ]
      }

      expect(response_json).to eq result
    end
  end

  describe "PUT /api/v1/insurance_companies/:id" do
    it "updates specify insurance_company" do
      auth_put :update, id: pingan.id,
                        insurance_company: { name: "人寿保险" }

      result = {
        data: {
          id: pingan.id,
          name: "人寿保险",
          company_id: tianche.id,
          created_at: iso8601_format("2015-01-10")
        }
      }

      expect(response_json).to eq result
    end

    it_should_behave_like "permission check", "业务设置" do
      let(:request_query) do
        auth_put :update, id: pingan.id,
                          insurance_company: { name: "人寿保险" }
      end
    end
  end

  describe "POST /api/v1/insurance_companies" do
    it "creates a insurance_company" do
      travel_to Time.zone.parse("2015-01-10")

      auth_post :create,
                insurance_company: {
                  name: "人寿保险"
                }

      baoma_4s = tianche.insurance_companies.find_by(name: "人寿保险")
      result = {
        data: {
          id: baoma_4s.id,
          name: "人寿保险",
          company_id: tianche.id,
          created_at: iso8601_format("2015-01-10")
        }
      }

      expect(response_json).to eq result
    end

    it_should_behave_like "permission check", "业务设置" do
      let(:request_query) do
        auth_post :create,
                  insurance_company: {
                    name: "人寿保险"
                  }
      end
    end
  end

  describe "DELETE /api/v1/insurance_companies/:id" do
    it "deletes specify insurance_company" do
      auth_delete :destroy, id: pingan.id

      result = {
        data: {
          id: pingan.id,
          name: pingan.name,
          company_id: tianche.id,
          created_at: iso8601_format("2015-01-10")
        }
      }

      expect(response_json).to eq result
    end

    it_should_behave_like "permission check", "业务设置" do
      let(:request_query) { auth_delete :destroy, id: pingan.id }
    end
  end
end
