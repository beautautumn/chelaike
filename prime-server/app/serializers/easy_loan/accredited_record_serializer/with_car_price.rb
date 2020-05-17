module EasyLoan
  module AccreditedRecordSerializer
    class WithCarPrice < Basic
      attributes :remaining_amount_wan, :estimate_car_price_wan

      def estimate_car_price_wan
        EasyLoanService::Lib.estimate_car_price_wan(
          scope[:car_id], object
        )
      end
    end
  end
end
