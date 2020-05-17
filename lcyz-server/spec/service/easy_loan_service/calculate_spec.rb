require "rails_helper"

RSpec.describe EasyLoanService::Calculate do
  fixtures :all

  let(:tianche) { companies(:tianche) }
  let(:current_month_debit) { easy_loan_debits(:debit_a) }
  let(:last_month_debit) { easy_loan_debits(:debit_b) }

  describe "init" do
    it "init successfully" do
      service = EasyLoanService::Calculate.new(tianche.id, Time.now)
      expect(service).to be_a(EasyLoanService::Calculate)
      expect(service.debit).to eq(current_month_debit)
    end

    it "init and create current_company's debit" do
      service = EasyLoanService::Calculate.new(tianche.id, Time.now.next_month)
      expect(service.debit).to have_attributes(:company_id => tianche.id)
    end
  end
end
