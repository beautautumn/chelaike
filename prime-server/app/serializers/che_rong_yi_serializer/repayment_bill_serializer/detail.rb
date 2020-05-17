module CheRongYiSerializer
  module RepaymentBillSerializer
    class Detail < ActiveModel::Serializer
      attributes :id, :loan_bill_id, :repayment_amount_cents, :state,
                 :repayment_amount_wan, :funder_company_id,
                 :funder_company_name, :debtor_id, :sp_company_id,
                 :apply_code, :created_at, :updated_at,
                 :credit_balance_amount_wan,
                 :current_use_amount_wan, :allow_part_repay,
                 :single_car_rate

      has_many :cars, serializer: CheRongYiSerializer::CarSerializer::Common
      has_many :histories, serializer: CheRongYiSerializer::RecordHistorySerializer::Common
      def created_at
        object.created_at.try(:strftime, "%Y-%m-%d")
      end

      def updated_at
        object.updated_at.try(:strftime, "%Y-%m-%d")
      end
    end
  end
end
