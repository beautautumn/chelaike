module EasyLoan
  module LoanBillSerializer
    class Detail < Basic
      attributes :return_amount_wan
      has_many :loan_bill_histories,
               serializer: EasyLoan::LoanBillHistorySerializer::Basic

      has_many :images, serializer: ImageSerializer::Common
      has_one :accredited_record, serializer: EasyLoan::AccreditedRecordSerializer::Basic
      belongs_to :company, serializer: CompanySerializer::Basic, if: :show_company?

      def return_amount_wan
        object.borrowed_amount_wan
      end

      def show_company?
        instance_options[:show_company]
      end
    end
  end
end
