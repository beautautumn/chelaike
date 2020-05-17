module Dw
  module Analysis
    class Car < Base
      # 收购总价
      def acquisition_amount(conditions)
        fact = Dw::AcquisitionFact
        fields = [Fields.acquisition_amount]
        dimensions = [:acquired_at_dimension, :car_dimension]

        result = search_by(fact, fields, dimensions, conditions).first
        return 0 if result.blank?

        result.fetch("acquisition_amount").to_f.round(2)
      end

      # 出库信息
      def out_stock_info(conditions, fact: nil)
        fact = Dw::OutOfStockFact.state_out_of_stock.current if fact.blank?

        fields = [
          Fields.out_stock_count,
          Fields.out_stock_amount,
          Fields.car_gross_profit,
          Fields.average_gross_profit
        ]

        result = search_by(fact, fields, out_of_stock_dimensions, conditions).first

        return out_stock_empty_info if result.blank?

        car_gross_profit = result.fetch("car_gross_profit").to_f
        out_stock_amount = result.fetch("out_stock_amount").to_f

        {
          out_stock_count: result.fetch("out_stock_count").to_i,
          out_stock_amount: out_stock_amount,
          car_gross_profit: car_gross_profit,
          car_gross_profit_rate: Dw::Analysis::Base.gross_profit_rate(
            car_gross_profit, out_stock_amount
          ),
          average_gross_profit: result.fetch("average_gross_profit").to_f
        }
      end

      def out_stock_empty_info
        {
          out_stock_count: 0,
          out_stock_amount: 0.0,
          car_gross_profit: 0.0,
          car_gross_profit_rate: "0.0%",
          average_gross_profit: 0.0
        }
      end

      def estimated_gross_profit_amount(conditions)
        fact = Dw::CarDimension
        fields = [Fields.estimated_gross_profit_amount]

        result = search_by(fact, fields, [], conditions).first
        return 0 if result.blank?

        result.fetch("estimated_gross_profit_amount").to_f.round(2)
      end
    end
  end
end
