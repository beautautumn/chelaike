module CheRongYiSerializer
  module RepaymentBillSerializer
    class Common < ActiveModel::Serializer
      attributes :id, :loan_bill_id, :repayment_amount_cents,
                 :state, :repayment_amount_wan
    end
  end
end
