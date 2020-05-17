require "rails_helper"

RSpec.describe V1::CheRongYi::AccreditedRecordsController, type: :controller do
  fixtures :all
  let(:zhangsan) { users(:zhangsan) }
  let(:aodi) { cars(:aodi) }

  before do
    give_authority(zhangsan, "融资管理")
    login_user(zhangsan)
    aodi.update!(estimate_price_wan: 10)
  end

  def mock_loan_accredited_record
    loan_accredited_record = CheRongYi::LoanAccreditedRecord.new(
      id: 1, debtor_id: 1, allow_part_repay: true,
      funder_company_id: 1, single_car_rate: 70,
      funder_company_name: "招行",
      sp_company_id: 1, limit_amount_wan: 50, in_use_amount_wan: 20,
      total_current_credit_wan: 80,
      current_credit_wan: 10
    )
    allow(CheRongYi::Api).to receive(:loan_accredited_records).and_return([loan_accredited_record])
  end

  describe "GET index" do
    before do
      mock_loan_accredited_record
    end

    it "得到某个车商的授信列表" do
      auth_get :index
      expect(response_json[:data]).to be_present
    end
  end

  describe "GET funder_companies" do
    before do
      mock_loan_accredited_record
    end

    it "得到所有的给这个车商授信过的资金公司列表" do
      auth_get :funder_companies
      expect(response_json[:data]).to be_present
    end
  end
end
