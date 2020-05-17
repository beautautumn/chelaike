require "rails_helper"

RSpec.describe EasyLoan::FunderCompaniesController, type: :controller do
  fixtures :all
  let(:zhangsan) { easy_loan_users(:easy_loan_user_a) }

  before do
    login_user(zhangsan)
  end

  describe "GET index" do
    it "list all funder companies" do
      loan_auth_get :index
      expect(response_json[:data].count).to eq 2
    end
  end
end
