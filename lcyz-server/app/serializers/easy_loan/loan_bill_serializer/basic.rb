module EasyLoan
  module LoanBillSerializer
    class Basic < ActiveModel::Serializer
      attributes :id, :company_id, :car_id, :sp_company_id, :car_basic_info,
                 :state, :state_history, :apply_code, :created_at,
                 :updated_at, :estimate_borrow_amount_wan, :borrowed_amount_wan,
                 :car_cover_image_url, :state_text,
                 :state_message_text

      belongs_to :funder_company, serializer: EasyLoan::FunderCompanySerializer::Basic

      def created_at
        object[:created_at].strftime("%Y-%m-%d")
      end

      def updated_at
        object[:updated_at].strftime("%Y-%m-%d")
      end
    end
  end
end
