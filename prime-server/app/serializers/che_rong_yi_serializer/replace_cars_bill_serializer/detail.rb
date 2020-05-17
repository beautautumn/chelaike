module CheRongYiSerializer
  module ReplaceCarsBillSerializer
    class Detail < ActiveModel::Serializer
      attributes :id, :loan_bill_id, :current_amount_cents,
                 :replace_amount_cents, :state, :debtor_id,
                 :loan_bill_code, :created_at, :updated_at,
                 :apply_code, :current_amount_wan,
                 :replace_amount_wan

      has_many :will_replace_cars, serializer: CheRongYiSerializer::CarSerializer::Common
      has_many :is_replaced_cars, serializer: CheRongYiSerializer::CarSerializer::Common
      has_many :no_replace_cars, serializer: CheRongYiSerializer::CarSerializer::Common

      has_many :histories, serializer: CheRongYiSerializer::RecordHistorySerializer::Common

      def created_at
        object.created_at.strftime("%Y-%m-%d")
      end

      def updated_at
        object.updated_at.strftime("%Y-%m-%d")
      end
    end
  end
end
