require "rails_helper"

RSpec.describe EasyLoanService::LoanBill do
  fixtures :all

  let(:zhangsan) { easy_loan_users(:easy_loan_user_a) }
  let(:tianche) { companies(:tianche) }
  let(:loan_bill) { easy_loan_loan_bills(:tianche_bill_a) }
  let(:tianche_sp) { easy_loan_sp_companies(:tianche_sp) }
  let(:gmc) { easy_loan_funder_companies(:gmc) }
  let(:tianche_accredited_record) { easy_loan_accredited_records(:tianche_accredited_record_gmc) }

  describe "#matched_easy_loan_users" do
    before do
      loan_bill.company.update!(
        province: "浙江省",
        city: "杭州市"
      )

      zhangsan.update!(city: "浙江省,杭州市")
    end

    it "得到属于同一城市的金融专员列表" do
      service = EasyLoanService::LoanBill.new(nil, loan_bill)
      users = service.matched_easy_loan_users
      expect(users).to match_array [zhangsan]
    end
  end

  describe "#change_state!" do
    before do
      loan_bill.update!(
        borrowed_amount_wan: 20,
        funder_company: gmc
      )
      tianche_accredited_record.update!(
        limit_amount_wan: 100,
        funder_company_id: gmc.id
      )
    end

    context "更新公司相关授信记录里已用额度" do
      it "状态为borrow_confirmed，增加该公司授信记录里的已用额度" do
        service = EasyLoanService::LoanBill.new(zhangsan, loan_bill)
        service.change_state!(:borrow_confirmed)
        expect(tianche_accredited_record.reload.in_use_amount_wan).to eq 20
      end

      it "状态为return_confirmed，减去该公司授信记录里的已用额度" do
        service = EasyLoanService::LoanBill.new(zhangsan, loan_bill)
        tianche_accredited_record.update!(in_use_amount_wan: 50)
        service.change_state!(:return_confirmed)
        expect(tianche_accredited_record.reload.in_use_amount_wan).to eq 30
      end

      it "won't change" do
        service = EasyLoanService::LoanBill.new(zhangsan, loan_bill)
        tianche_accredited_record.update!(in_use_amount_wan: 50)
        service.change_state!(:borrow_applied)
        expect(tianche_accredited_record.reload.in_use_amount_wan).to eq 50
      end
    end
  end
end
