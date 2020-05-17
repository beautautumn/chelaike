module CompanySerializer
  class WithDebit < Basic
    has_one :latest_loan_debit, serializer: EasyLoan::DebitSerializer::Basic

    has_many :accredited_records, serializer: EasyLoan::AccreditedRecordSerializer::Basic
  end
end
