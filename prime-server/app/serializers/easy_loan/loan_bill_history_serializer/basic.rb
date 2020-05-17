module EasyLoan
  module LoanBillHistorySerializer
    class Basic < ActiveModel::Serializer
      attributes :id, :user_id, :bill_state, :message, :note,
                 :state_text, :created_at, :updated_at

      def created_at
        object[:created_at].strftime("%Y-%m-%d %H:%M")
      end

      def updated_at
        object[:updated_at].strftime("%Y-%m-%d %H:%M")
      end
    end
  end
end
