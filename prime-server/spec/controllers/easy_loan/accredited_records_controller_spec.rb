require "rails_helper"

RSpec.describe EasyLoan::AccreditedRecordsController, type: :controller do
  fixtures :all

  let(:zhangsan) { easy_loan_users(:easy_loan_user_a) }
  let(:tianche) { companies(:tianche) }
  let(:gmc) { easy_loan_funder_companies(:gmc) }
  let(:icbc) { easy_loan_funder_companies(:icbc) }
  let(:tianche_finacing) { easy_loan_sp_companies(:tianche_sp) }
  let(:debit) { easy_loan_debits(:debit_a)}

  before do
    login_user(zhangsan)
  end

  describe "POST create" do
    it "创建一条车商公司授信记录" do
      EasyLoan::AccreditedRecord.destroy_all
      expect do
        loan_auth_post :create,
                       records: {
                         company_id: tianche.id,
                         accredited_records: [
                           {
                             limit_amount_wan: 101,
                             funder_company_id: gmc.id,
                             single_car_rate: 5
                           },
                           {
                             limit_amount_wan: 95,
                             funder_company_id: icbc.id,
                             single_car_rate: 6
                           }
                         ]
                       }
      end.to change { EasyLoan::AccreditedRecord.count }.by(2)
    end

    it "如果已存在该资金公司，更新授信记录" do
      EasyLoan::AccreditedRecord.destroy_all
      gmc_accredited = EasyLoan::AccreditedRecord.create!(
        company_id: tianche.id,
        funder_company_id: gmc.id,
        limit_amount_wan: 50
      )

      icbc_accredited = EasyLoan::AccreditedRecord.create!(
        company_id: tianche.id,
        funder_company_id: icbc.id,
        limit_amount_wan: 70
      )

      loan_auth_post :create,
                     records: {
                       company_id: tianche.id,
                       accredited_records: [
                         {
                           limit_amount_wan: 101,
                           funder_company_id: gmc.id,
                           single_car_rate: 5
                         },
                         {
                           limit_amount_wan: 95,
                           funder_company_id: icbc.id,
                           single_car_rate: 6
                         }
                       ]
                     }

      expect(gmc_accredited.reload.limit_amount_wan).to eq 101
      expect(icbc_accredited.reload.limit_amount_wan).to eq 95
    end
  end

  describe "GET index" do
    before do
      @tianche_accredited_record1 = EasyLoan::AccreditedRecord.create!(
        company_id: tianche.id,
        sp_company_id: tianche_finacing.id,
        funder_company_id: gmc.id,
        limit_amount_wan: 101
      )

      @tianche_accredited_record2 = EasyLoan::AccreditedRecord.create!(
        company_id: tianche.id,
        sp_company_id: tianche_finacing.id,
        funder_company_id: icbc.id,
        limit_amount_wan: 60
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

    context "同一家公司授信多次" do
      it "只列出一次该公司" do
        tianche.easy_loan_debits.create!(
          comprehensive_rating: 2.4,
          operating_health: 3.7,
          industry_rating: 5.0
        )

        loan_auth_get :index
        expect(response_json[:data].count).to eq 1
      end
    end

    it "显示正确的综合评分" do
      loan_auth_get :index, query: {
        name_cont: "天车"
      }
      expect(response_json[:data].first.fetch(:accredited_scope)).to eq "3.5"
    end

    it "列出未授信的公司" do
      loan_auth_get :index, state: false
      expect(response_json[:data].count).to eq 3
    end

    it "根据正确商家名称搜索授信公司" do
      loan_auth_get :index, state: "false", query: {
        name_cont: "华纳兄弟"
      }
      expect(response_json[:data].count).to eq 1
    end

    it "根据错误商家名称搜索授信公司" do
      loan_auth_get :index, state: "false", query: {
        name_cont: "不存在"
      }
      expect(response_json[:data].count).to eq 0
    end
  end
end
