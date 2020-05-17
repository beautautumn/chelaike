module EasyLoanSerializer
  module LoanBillSerializer
    class Detail < Common
      has_many :loan_bill_histories,
               serializer: EasyLoanSerializer::LoanBillHistorySerializer::Basic
    end
  end
end
