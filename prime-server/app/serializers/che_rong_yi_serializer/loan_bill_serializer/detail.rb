module CheRongYiSerializer
  module LoanBillSerializer
    class Detail < Common
      has_many :histories, serializer: CheRongYiSerializer::RecordHistorySerializer::Common

      has_many :original_cars, serializer: CheRongYiSerializer::CarSerializer::Common
    end
  end
end
