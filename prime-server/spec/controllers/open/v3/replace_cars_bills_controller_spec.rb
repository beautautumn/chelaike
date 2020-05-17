require "rails_helper"

RSpec.describe Open::V3::ReplaceCarsBillsController do
  fixtures :all

  let(:pixar) { shops(:pixar) }

  def replace_cars_bill_params(extra_params = {})
    {
      id: 1, loan_bill_id: 1,
      current_amount_cents: 1_000_000,
      replace_amount_cents: 2_000_000,
      state: :init,
      debtor_id: pixar.id,
      loan_bill_code: "asdf",
      original_cars: "aodi A4",
      new_cars: "benz s"
    }.merge(extra_params)
  end

  describe "POST notify" do
    it "创建一条新的操作记录" do
      expect do
        cherongyi_auth_post :notify, replace_cars_bill: replace_cars_bill_params
      end.to change { OperationRecord.count }.by(1)
    end
  end
end
