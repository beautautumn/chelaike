require "rails_helper"

RSpec.describe V1::AccreditedRecordsController do
  fixtures :all
  let(:zhangsan) { users(:zhangsan) }
  let(:tianche) { companies(:tianche) }
  let(:gmc) { easy_loan_funder_companies(:gmc) }
  let(:icbc) { easy_loan_funder_companies(:icbc) }
  let(:tianche_finacing) { easy_loan_sp_companies(:tianche_sp) }

  before do
    login_user(zhangsan)
    give_authority(zhangsan, "融资管理")
  end

  describe "GET index" do
    it "列出所有这家公司的授信记录" do
      EasyLoan::AccreditedRecord.create(
        company_id: tianche.id,
        funder_company_id: gmc.id,
        sp_company_id: tianche_finacing.id,
        limit_amount_wan: 100,
        in_use_amount_wan: 20
      )

      EasyLoan::AccreditedRecord.create(
        company_id: tianche.id,
        funder_company_id: icbc.id,
        sp_company_id: tianche_finacing.id,
        limit_amount_wan: 200,
        in_use_amount_wan: 10
      )

      auth_get :index
      expect(response_json[:meta][:total_amount_wan]).to eq 300
      expect(response_json[:meta][:total_in_use_wan]).to eq 30
    end
  end
end
