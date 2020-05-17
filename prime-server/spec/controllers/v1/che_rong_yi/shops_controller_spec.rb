require "rails_helper"

RSpec.describe V1::CheRongYi::ShopsController, type: :controller do
  fixtures :all

  let(:zhangsan) { users(:zhangsan) }
  let(:aodi) { cars(:aodi) }

  def mock_loan_accredited_record
    loan_accredited_record = CheRongYi::LoanAccreditedRecord.new(
      id: 1, debtor_id: 1, allow_part_repay: true,
      funder_company_id: 1, single_car_rate: 70,
      sp_company_id: 1, limit_amount_wan: 50, in_use_amount_wan: 20
    )
    allow(CheRongYi::Api).to receive(:loan_accredited_records).and_return([loan_accredited_record])
  end

  before do
    give_authority(zhangsan, "融资管理")
    login_user(zhangsan)
    zhangsan.update!(shop_id: 1)
  end

  describe "GET check_accredited" do
    before do
      mock_loan_accredited_record
    end

    context "车商未授信" do
      it "返回错误提示" do
        allow(CheRongYi::Api).to receive(:loan_accredited_records).and_return([])
        auth_get :check_accredited
        expect(response_json[:data]).to be_present
      end
    end

    context "有授信记录" do
      it "返回正常信息" do
        auth_get :check_accredited
        expect(response_json[:data]).to be_present
      end
    end
  end
end
