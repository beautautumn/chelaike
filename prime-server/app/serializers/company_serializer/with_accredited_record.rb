module CompanySerializer
  class WithAccreditedRecord < CompanySerializer::Basic
    attributes :accredited_scope, :accredited_mount
    has_many :accredited_records, serializer: EasyLoan::AccreditedRecordSerializer::Basic

    has_one :latest_loan_debit, serializer: EasyLoan::DebitSerializer::Basic

    def accredited_scope
      object.latest_loan_debit.try(:comprehensive_rating).try(:to_f).try(:round, 1).to_s
    end

    def accredited_mount
      object.accredited_records.inject(0) { |a, e| a + e.limit_amount_wan }
    end
  end
end
