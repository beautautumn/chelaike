require "rails_helper"

RSpec.describe V1::MortgageCompaniesController do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }
  let(:tianche) { companies(:tianche) }
  let(:cmb_china) { mortgage_companies(:cmb_china) }

  before do
    give_authority(zhangsan, "业务设置")
    login_user(zhangsan)
  end

  describe "GET /api/v1/mortgage_companies" do
    it "returns all mortgage_companies for specify company" do
      auth_get :index

      result = {
        data: [
          {
            id: cmb_china.id,
            name: cmb_china.name,
            company_id: tianche.id,
            created_at: iso8601_format("2015-01-10")
          }
        ]
      }

      expect(response_json).to eq result
    end
  end

  describe "POST /api/v1/mortgage_companies" do
    it "creates a mortgage_company for specify company" do
      travel_to Time.zone.parse("2015-01-10")
      auth_post :create,
                mortgage_company: {
                  name: "人民银行"
                }

      changan = MortgageCompany.find_by(name: "人民银行")

      result = {
        data: {
          id: changan.id,
          name: "人民银行",
          company_id: tianche.id,
          created_at: iso8601_format("2015-01-10")
        }
      }

      expect(response_json).to eq result
    end

    it_should_behave_like "permission check", "业务设置" do
      let(:request_query) do
        auth_post :create,
                  mortgage_company: {
                    name: "人民银行"
                  }
      end
    end
  end

  describe "PUT /api/v1/mortgage_companies/:id" do
    it "updates a mortgage_company" do
      auth_put :update, id: cmb_china.id,
                        mortgage_company: {
                          name: "abc"
                        }

      result = {
        data: {
          id: cmb_china.id,
          name: "abc",
          company_id: tianche.id,
          created_at: iso8601_format("2015-01-10")
        }
      }

      expect(response_json).to eq result
    end

    it_should_behave_like "permission check", "业务设置" do
      let(:request_query) do
        auth_put :update, id: cmb_china.id,
                          mortgage_company: {
                            name: "abc"
                          }
      end
    end
  end

  describe "DELETE /api/v1/mortgage_companies/:id" do
    it "deletes a mortgage_company" do
      auth_delete :destroy, id: cmb_china.id

      result = {
        data: {
          id: cmb_china.id,
          name: cmb_china.name,
          company_id: tianche.id,
          created_at: iso8601_format("2015-01-10")
        }
      }

      expect(response_json).to eq result
    end

    it_should_behave_like "permission check", "业务设置" do
      let(:request_query) do
        auth_delete :destroy, id: cmb_china.id
      end
    end
  end
end
