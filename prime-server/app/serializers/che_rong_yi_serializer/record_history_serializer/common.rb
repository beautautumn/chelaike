module CheRongYiSerializer
  module RecordHistorySerializer
    class Common < ActiveModel::Serializer
      attributes :loan_bill_id, :operator_id, :operator_type, :operator_name,
                 :content_id, :content_type, :content_state,
                 :bill_state, :message,
                 :note, :created_at, :updated_at, :content_state_text,
                 :message_text

      def created_at
        object.created_at.try(:strftime, "%Y-%m-%d %H:%M")
      end

      def updated_at
        object.updated_at.try(:strftime, "%Y-%m-%d %H:%M")
      end
    end
  end
end
