require "rails_helper"

RSpec.describe V1::EasyLoanDebitsController do
  fixtures :all
  let(:zhangsan) { users(:zhangsan) }
  let(:tianche) { companies(:tianche) }
  let(:gmc) { easy_loan_funder_companies(:gmc) }
  let(:icbc) { easy_loan_funder_companies(:icbc) }
  let(:tianche_finacing) { easy_loan_sp_companies(:tianche_sp) }

  before do
    login_user(zhangsan)

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
    it "得到这家公司的库融评级详情" do
      tianche.easy_loan_debits.create!(
        comprehensive_rating: 2.4,
        operating_health: 3.7,
        industry_rating: 5.0
      )

      auth_get :show
      expect(response_json[:data]).to be_present
    end
  end
end
