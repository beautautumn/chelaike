module FinanceSerializer
  module CarIncomeSerializer
    class Common < ActiveModel::Serializer
      attributes :id, :car_id, :company_id, :shop_id, :acquisition_price_wan,
                 :payment_wan, :prepare_cost_yuan,
                 :handling_charge_yuan, :commission_yuan, :percentage_yuan,
                 :fund_cost_yuan, :other_cost_yuan, :closing_cost_wan,
                 :receipt_wan, :other_profit_yuan, :fund_rate,
                 :created_at, :updated_at, :name, :stock_number, :vin,
                 :sell_info, :acquisition_info, :acquisition_type,
                 :gross_profit, :gross_margin, :net_profit, :net_margin,
                 :state, :stock_age_days, :loan_wan

      def shop_id
        object.car.try(:shop_id)
      end

      def name
        object.car.try(:name)
      end

      def vin
        object.car.try(:vin)
      end

      def stock_number
        object.car.try(:stock_number)
      end

      def sell_info
        {
          seller_id: object.car.try(:seller_id),
          seller: object.car.try(:seller).try(:name),
          date: object.car.try(:stock_out_at)
        }
      end

      def acquisition_info
        {
          shop_id: object.car.try(:shop_id),
          acquirer_id: object.car.try(:acquirer_id),
          acquirer: object.car.try(:acquirer).try(:name),
          date: object.car.try(:acquired_at)
        }
      end

      def acquisition_type
        object.car.try(:acquisition_type)
      end

      def state
        object.car.try(:state)
      end

      def stock_age_days
        object.car.try(:stock_age_days)
      end
    end
  end
end
