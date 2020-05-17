# 车容易里车商授信记录
module CheRongYi
  class LoanAccreditedRecord < Base
    attribute :id, Integer
    attribute :debtor_id, Integer
    attribute :allow_part_repay, Boolean
    attribute :limit_amount_cents, Integer
    attribute :in_use_amount_cents, Integer
    attribute :funder_company_id, Integer
    attribute :created_at, DateTime
    attribute :updated_at, DateTime
    attribute :single_car_rate, Float # 70, 80
    attribute :sp_company_id, Integer
    attribute :limit_amount_wan, Float # 最大授信
    attribute :in_use_amount_wan, Float # 已使用额度，当前用款
    attribute :funder_company_name, String # 资金公司名
    attribute :latest_limit_amout_wan, Float # 最近一次授信历史里记录的授信额度
    attribute :total_current_credit_wan, Float # 这家公司的总当前授信额度
    attribute :current_credit_wan, Float # 每个授信记录里的当前授信额度
    attribute :latest_current_credit_wan, Float # 最近一次授信里的“当前授信额度”

    def unused_amount_wan
      current_credit_wan - in_use_amount_wan
    end

    def show_text
      "#{funder_company_name}，当前额度从#{latest_current_credit_wan}万调整为#{current_credit_wan}万"
    end
  end
end
