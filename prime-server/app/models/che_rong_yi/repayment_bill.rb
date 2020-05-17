module CheRongYi
  class RepaymentBill < Base
    attribute :id, Integer
    attribute :loan_bill_id, Integer
    attribute :repayment_amount_cents, Integer
    attribute :state, String
    attribute :repayment_amount_wan, Float
    attribute :funder_company_id, Integer
    attribute :funder_company_name, String
    attribute :debtor_id, Integer # 借款方ID
    attribute :debtor_name, String
    attribute :debtor_address, String
    attribute :contact_name, String
    attribute :contact_phone, String
    attribute :shop_id, Integer # 车来客里的车商id
    attribute :sp_company_id, Integer
    attribute :apply_code, String
    attribute :created_at, DateTime
    attribute :updated_at, DateTime
    attribute :credit_balance_amount_wan, Float # 授信余额
    attribute :current_use_amount_wan, Float # 本单用款
    attribute :allow_part_repay, Boolean
    attribute :single_car_rate, Float

    attribute :cars, Array[CheRongYi::Car]
    attribute :histories, Array[CheRongYi::LoanBillOperationRecordHistory]
  end
end
