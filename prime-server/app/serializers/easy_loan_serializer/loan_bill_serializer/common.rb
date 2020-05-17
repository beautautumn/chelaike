module EasyLoanSerializer
  module LoanBillSerializer
    class Common < ActiveModel::Serializer
      attributes :id, :borrowed_amount_wan, :company_id,
                 :car_id, :sp_company_id, :funder_company_id,
                 :car_basic_info, :state, :state_history, :state_en,
                 :apply_code, :created_at, :latest_note, :license_images,
                 :estimate_borrow_amount_wan

      belongs_to :company, serializer: CompanySerializer::Mini
      belongs_to :car, serializer: CarSerializer::Mini
      belongs_to :funder_company, serializer: FunderCompanySerializer::Basic

      def state
        EasyLoan::LoanBill::STATE_TEXT.fetch(object.state.to_sym)
      end

      def state_en
        object.state
      end

      def created_at
        Util::Datetime.date_with_time_format(object.created_at)
      end

      def latest_note
        object.latest_state_history.note
      end

      def license_images
        object.images
      end

      def borrowed_amount_wan
        object.latest_state_history.amount_wan
      end
    end
  end
end
