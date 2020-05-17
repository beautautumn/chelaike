module CheRongYi
  class LoanBillService
    class Result
      attr_accessor :status, :data

      def initialize(status, data)
        @status = status
        @data = data
      end
    end

    attr_accessor :loan_bill_id, :loan_bill, :user

    def initialize(loan_bill_id, user = nil)
      @loan_bill_id = loan_bill_id
      @loan_bill = CheRongYi::Api.loan_bill(loan_bill_id)
      @user = user
    end

    # 申请还款
    def repay(remaining_car_ids:, repay_amount_wan:, repay_car_ids:)
      # TODO: 这里有问题
      accredited_record = CheRongYi::Api.loan_accredited_records(@loan_bill.debtor_id).first

      cars_estimate_wan = Car.where(id: remaining_car_ids).inject(0) do |a, e|
        a + e.estimate_price_wan.to_i
      end

      remaining_cars_estimate_wan = cars_estimate_wan * accredited_record.single_car_rate / 100
      remaining_loan_bill_wan = loan_bill.remaining_amount_wan - repay_amount_wan.to_d

      return Result.new(false, nil) unless remaining_cars_estimate_wan > remaining_loan_bill_wan

      service = CheRongYi::RepaymentBillService.new
      repayment_bill = service.create(
        remaining_car_ids: remaining_car_ids,
        repay_amount_wan: repay_amount_wan,
        repay_car_ids: repay_car_ids
      )
      Result.new(true, repayment_bill)
    end
  end
end
