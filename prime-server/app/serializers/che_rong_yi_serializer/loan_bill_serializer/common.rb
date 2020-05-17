module CheRongYiSerializer
  module LoanBillSerializer
    class Common < ActiveModel::Serializer
      attributes :id, :debtor_id, :sp_company_id, :funder_company_id, :state,
                 :apply_code, :created_at, :updated_at,
                 :estimate_borrow_amount_cents, :borrowed_amount_cents,
                 :estimate_borrow_amount_wan, :borrowed_amount_wan,
                 :remaining_amount_wan,
                 :funder_company_name, :latest_history_note,
                 :state_message_text,
                 :state_text, :shop_id,
                 :init_borrowed_amount_wan

      has_many :cars, serializer: CheRongYiSerializer::CarSerializer::Common

      def created_at
        object.created_at.strftime("%Y-%m-%d")
      end

      def updated_at
        object.updated_at.strftime("%Y-%m-%d")
      end
    end
  end
end
