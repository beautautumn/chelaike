module CheRongYi
  class ReplaceCarsBill < Base
    attribute :id, Integer
    attribute :loan_bill_id, Integer
    attribute :current_amount_cents, Integer
    attribute :replace_amount_cents, Integer
    attribute :state, String
    attribute :debtor_id, Integer # 借款方ID
    attribute :debtor_name, String
    attribute :debtor_address, String
    attribute :contact_name, String
    attribute :contact_phone, String
    attribute :shop_id, Integer # 车来客里的车商ID
    attribute :loan_bill_code, String # 对应的借款单编号
    attribute :created_at, DateTime
    attribute :updated_at, DateTime
    attribute :apply_code, String # 换车单编号
    attribute :funder_company_name, String # 所属借款单里的资金公司

    attribute :will_replace_cars, Array[CheRongYi::Car] # 要替换上来的车辆id
    attribute :is_replaced_cars, Array[CheRongYi::Car] # 被替换下去的车辆
    attribute :no_replace_cars, Array[CheRongYi::Car] # 未被替换的原车辆
    attribute :loan_cars, Array[CheRongYi::Car] # 在押车辆
    attribute :replace_cars, Array[CheRongYi::Car] # 未被替换的原车辆
    attribute :histories, Array[CheRongYi::LoanBillOperationRecordHistory]

    def state_text
      {
        replace_apply: "换车申请",
        replace_submitted: "换车提交",
        replace_review: "换车审核",
        replace_confirmed: "已换车",
        replace_refused: "换车失败"
      }.fetch(state.to_sym, "换车申请")
    end

    def current_amount_wan
      current_amount_cents.to_i / 1000000.0
    end

    def replace_amount_wan
      replace_amount_cents.to_i / 1000000.0
    end

    # 原车辆
    def original_cars_name
      is_replaced_cars.map(&:name).try(:join, "，")
    end

    # 替换车辆
    def new_cars_name
      will_replace_cars.map(&:name).try(:join, "，")
    end
  end
end
