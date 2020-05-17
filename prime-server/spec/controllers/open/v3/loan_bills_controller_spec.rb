require "rails_helper"

RSpec.describe Open::V3::LoanBillsController do
  fixtures :all

  let(:pixar) { shops(:pixar) }
  let(:aodi) { cars(:aodi) }

  def loan_bill_params(extra_params = {})
    {
      id: 1,
      debtor_id: pixar.id,
      sp_company_id: 1,
      funder_company_id: 1,
      state: :borrow_applied,
      apply_code: "asdf",
      estimate_borrow_amount_cents: 1_000_000,
      borrowed_amount_cents: 1_000_000,
      estimate_borrow_amount_wan: 1,
      borrowed_amount_wan: 1,
      remaining_amount_wan: 1, # 剩下未还款金额
      funder_company_name: "天车资金公司", # 资金公司名
      latest_history_note: "最新的操作记录里的备注",  # 最新的操作记录备注
      cars: [
        {
          id: 1,
          chelaike_car_id: aodi.id
        }
      ]
    }.merge(extra_params)
  end

  def accredited_record_params(extra_parmas = {})
    {
      id: 6053,
      debtor_id: 197,
      current_credit_wan: 30.00,
      funder_company_name: "招商",
      latest_current_credit_wan: 0
    }.merge(extra_parmas)
  end

  describe "POST notidy" do
    it "创建消息" do
      expect do
        cherongyi_auth_post :notify, type: :loan_bill,
                            data: { loan_bill: loan_bill_params }
      end.to change { OperationRecord.count }.by (1)
    end

    context "授信额度调整" do
      it "创建消息" do
        expect do
          cherongyi_auth_post :notify, type: :accredited_record,
                              data: { accredited_record:
                                        [
                                          accredited_record_params,
                                          accredited_record_params(funder_company_name: "建行")
                                        ]
                                    }
        end.to change { OperationRecord.count }.by (1)
      end
    end
  end
end
