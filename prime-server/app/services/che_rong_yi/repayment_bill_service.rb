module CheRongYi
  class RepaymentBillService
    attr_accessor :repayment_bill

    def initialize
    end

    def create(remaining_car_ids:, repay_amount_wan:, repay_car_ids:)
      # TODO: 访问车容易接口，创建一条还款单，得到返回，封装对象
    end
  end
end
