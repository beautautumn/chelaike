# == Schema Information
#
# Table name: easy_loan_loan_bills # 借款单
#
#  id                :integer          not null, primary key # 借款单
#  company_id        :integer                                # 借款公司
#  car_id            :integer                                # 用哪辆车进行借款
#  sp_company_id     :integer                                # 通过哪家sp公司
#  funder_company_id :integer                                # 提供资金公司
#  car_basic_info    :jsonb                                  # 冗余车辆基本信息
#  state             :string                                 # 借款单当前状态
#  state_history     :jsonb                                  # 状态变更历史记录概要
#  apply_code        :string                                 # 申请编号
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require "rails_helper"

RSpec.describe EasyLoan::LoanBillsController, type: :controller do
  fixtures :all

  let(:zhangsan) { easy_loan_users(:easy_loan_user_a) }
  let(:tianche) { companies(:tianche) }
  let(:loan_bill) { easy_loan_loan_bills(:tianche_bill_a) }
  let(:tianche_sp) { easy_loan_sp_companies(:tianche_sp) }
  let(:gmc) { easy_loan_funder_companies(:gmc) }

  before do
    login_user(zhangsan)
  end

  describe "GET index" do
    before do
      give_authority(zhangsan, "查看全部申请单")
    end

    it "list all easy loan bills" do
      loan_auth_get :index

      expect(response_json[:data].count).to eq 7
    end

    it "render loan bill items with state_en attribute" do
      loan_auth_get :index
      expect(response_json[:data].first[:state_en]).to eq("borrow_applied")
    end

    context "list easy loan bills by condition" do
      context "loan bills filter by specify column condition" do
        it "by company_id" do
          loan_auth_get :index, query: {
            company_id_eq: tianche.id
          }
          expect(response_json[:data].count).to eq 4
        end

        it "by loan state" do
          loan_auth_get :index, query: {
            state_eq: "borrow_applied"
          }
          expect(response_json.fetch(:data).count).to eq(3)
        end

        it "by car brand name" do
          loan_auth_get :index, query: {
            car_brand_name_eq: "奥迪"
          }
          expect(response_json[:data].count).to eq 5
        end
      end

      # 品牌、车系、商家文字条件搜索
      context "loan bills filter by search condition" do
        # 车型名称搜索
        it "by brand_name condition" do
          loan_auth_get :index, query: {
            car_brand_name_or_car_series_name_or_company_name_cont: "奥迪"
          }
          expect(response_json[:data].count).to eq 5
        end

        # 车系名称搜索
        it "by series_name condition" do
          loan_auth_get :index, query: {
            car_brand_name_or_car_series_name_or_company_name_cont: "奥迪A3"
          }
          expect(response_json[:data].count).to eq 3
        end

        # 商家名称搜索
        it "by company name condition" do
          loan_auth_get :index, query: {
            car_brand_name_or_car_series_name_or_company_name_cont: "天车二手车"
          }
          expect(response_json[:data].count).to eq 4
        end
      end
    end
    context "list loan_bills, which company city column is 深圳市" do
      before do
        zhangsan.update(city: "广东省,深圳市", authorities: [])
        tianche.update(city: "深圳市")
      end
      it "list all loan_bills for easy_loan_user, which is in shenzhen" do
        loan_auth_get :index
        expect(response_json[:data].count).to eq 4
      end
    end
  end

  describe "GET show" do
    it "get a loan bill detail" do
      loan_auth_get :show, id: loan_bill.id
      expect(response_json[:data]).to be_present
    end
  end

  describe "PUT update" do
    before do
      loan_bill.update!(funder_company_id: gmc.id)
    end

    it "更新借款单状态" do
      loan_bill_params = {
        state: "reviewed", borrowed_amount_wan: 20, latest_note: "good"
      }

      loan_auth_put :update, id: loan_bill.id, loan_bill: loan_bill_params
      loan_bill.reload
      state_history = loan_bill.latest_state_history
      expect(loan_bill.state).to match "reviewed"
      expect(state_history.amount_wan).to eq 20
      expect(state_history.note).to eq "good"
    end

    it "创建一条车来客操作记录" do
      expect do
        loan_auth_put :update, id: loan_bill.id, loan_bill: { state: "reviewed" }
      end.to change { OperationRecord.count }.by 1
    end

    it "创建一条车来客消息"
  end

  describe "GET brands" do
    it "得到这家sp公司里的所有借款车辆的品牌" do
      loan_auth_get :brands
      expect(response_json[:data].count).to eq 1
    end
  end

  describe "GET brand_and_series" do
    it "得到所有品牌跟车系" do
      loan_auth_get :brand_and_series
      expect(response_json).to be_present
    end
  end
end
