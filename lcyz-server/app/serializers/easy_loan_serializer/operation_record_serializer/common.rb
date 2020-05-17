module EasyLoanSerializer
  module OperationRecordSerializer
    class Common < ActiveModel::Serializer
      attributes :id, :targetable_id, :targetable_type, :operation_record_type,
                 :user_id, :messages, :sp_company_id, :created_at,
                 :updated_at, :user_type, :state_message_text

      def created_at
        object.created_at.strftime("%Y-%m-%d %H:%M")
      end
    end
  end
end
