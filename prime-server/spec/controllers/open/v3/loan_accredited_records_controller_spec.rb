require "rails_helper"

RSpec.describe Open::V3::LoanAccreditedRecordsController do
  fixtures :all

  let(:pixar) { shops(:pixar) }

  def loan_accredited_record_params(extra_params = {})
    {
      id: 1, debtor_id: pixar.id,
      allow_part_repay: true,
      limit_amount_cents: 1_000_000,
      in_use_amount_cents: 500_000,
      funder_company_id: 1,
      single_car_rate: 0.7,
      sp_company_id: 1,
      limit_amount_wan: 1,
      in_use_amount_wan: 0.5,
      funder_company_name: "天车有钱公司",
      latest_limit_amout_wan: 0.8
    }.merge(extra_params)
  end

  describe "POST notify" do
    it "创建一条操作记录" do
      expect do
        cherongyi_auth_post :notify, loan_accredited_record: loan_accredited_record_params
      end.to change { OperationRecord.count }.by(1)
    end
  end
end
