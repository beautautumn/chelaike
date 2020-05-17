module FinanceSerializer
  module ShopFeeSerializer
    class Common < ActiveModel::Serializer
      attributes :id, :shop_id, :month, :note,
                 :location_rent_yuan, :salary_yuan, :social_insurance_yuan,
                 :bonus_yuan, :marketing_expenses_yuan, :energy_fee_yuan,
                 :office_fee_yuan, :communication_fee_yuan, :other_cost_yuan,
                 :other_profit_yuan, :car_cost_wan, :sales_revenue_wan,
                 :gross_profit, :gross_margin, :net_profit, :net_margin
    end
  end
end
