module EasyLoanSerializer
  module LoanBillHistorySerializer
    class Basic < ActiveModel::Serializer
      attributes :id, :bill_state, :note, :created_at

      def created_at
        object[:created_at].strftime("%Y-%m-%d")
      end
    end
  end
end
