module CheRongYi
  class LoanBill < Base
    attribute :id, Integer
    attribute :debtor_id, Integer
    attribute :sp_company_id, Integer
    attribute :funder_company_id, Integer
    attribute :state, String
    attribute :apply_code, String
    attribute :created_at, DateTime
    attribute :updated_at, DateTime
    attribute :estimate_borrow_amount_cents, Integer
    attribute :borrowed_amount_cents, Integer
    attribute :estimate_borrow_amount_wan, Float
    attribute :borrowed_amount_wan, Float
    attribute :remaining_amount_wan, Float # 剩下未还款金额
    attribute :funder_company_name, String # 资金公司名
    attribute :latest_history_note, String # 最新的操作记录备注
    attribute :state_message_text, String # 申请借款或实借款金额
    attribute :shop_id, Integer # 车来客里的车商ID
    attribute :init_borrowed_amount_cents, Integer # 初始借款出的的金额
    attribute :init_borrowed_amount_wan, Float # 初始借款出的的金额

    attribute :cars, Array[CheRongYi::Car]
    attribute :original_cars, Array[CheRongYi::Car]
    attribute :histories, Array[CheRongYi::LoanBillOperationRecordHistory]

    extend Enumerize
    extend EnumerizeWithGroups

    # 借款中，已放款，已拒绝, 还款中，已关闭，已取消
    enumerize :state,
              in: %i(
                borrow_applied borrow_submitted reviewed
                borrowing
                borrow_confirmed borrow_refused
                return_applied return_submitted return_confirmed
                return_closed return_canceled
                replace_apply
                replace_submitted
                replace_review
                replace_confirmed
                replace_refused
                returning closed canceled
              )

    def state_text
      {
        "borrow_applied" => "借款申请",
        "borrow_submitted" => "借款提交",
        "reviewed" => "借款审核",
        "borrowing" => "借款中",
        "borrow_confirmed" => "已放款",
        "borrow_refused" => "已拒绝",
        "return_applied" => "还款申请",
        "return_submitted" => "还款提交",
        "return_confirmed" => "还款确认",
        "return_closed" => "还款关闭",
        "return_canceled" => "还款取消",
        "returning" => "还款中",
        "replace_apply" => "换车申请",
        "replace_submitted" => "换车提交",
        "replace_review" => "换车审核",
        "replace_confirmed" => "已换车",
        "replace_refused" => "换车失败",
        "closed" => "已关闭",
        "canceled" => "已取消"
      }.fetch(state, "借款中")
    end

    def cars_name
      cars.map(&:name).join("，")
    end

    def cars_name_by_id
      chelaike_cars = ::Car.where(id: cars.map(&:chelaike_car_id))
      return "" unless chelaike_cars
      chelaike_cars.map(&:system_name).join("，")
    end
  end
end
