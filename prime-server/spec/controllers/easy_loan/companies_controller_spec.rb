require "rails_helper"

RSpec.describe EasyLoan::CompaniesController, type: :controller do
  fixtures :all

  let(:zhangsan) { easy_loan_users(:easy_loan_user_a) }
  let(:tianche) { companies(:tianche) }
  let(:loan_bill) { easy_loan_loan_bills(:tianche_bill_a) }
  let(:tianche_sp) { easy_loan_sp_companies(:tianche_sp) }
  let(:gmc) { easy_loan_funder_companies(:gmc) }
  let(:icbc) { easy_loan_funder_companies(:icbc) }
  let(:tianche_finacing) { easy_loan_sp_companies(:tianche_sp) }

  before do
    login_user(zhangsan)

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

    EasyLoan::RatingStatement.create!(
      score: 3, rate_type: :comprehensive_rating,
      content: "comprehensive_rating ranking less than 3"
    )
    EasyLoan::RatingStatement.create!(
      score: 4, rate_type: :operating_health,
      content: "operating_health ranking less than 4"
    )
    EasyLoan::RatingStatement.create!(
      score: 5, rate_type: :industry_rating,
      content: "industry_rating ranking less than 5"
    )
  end

  describe "GET show" do
    it "得到某公司详情，并带有库存评级信息" do
      tianche.easy_loan_debits.create!(
        comprehensive_rating: 2.4,
        operating_health: 3.7,
        industry_rating: 5.0
      )
      loan_auth_get :show, id: tianche.id
      expect(response_json[:data][:latest_loan_debit]).to be_present
    end
  end
end
