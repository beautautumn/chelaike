module Dw
  module Analysis
    class StockAge < Base
      def stock_info(conditions)
        fact = Dw::AcquisitionFact

        fields = [
          stock_age_range_sql,
          Fields.acquisition_count,
          Fields.acquisition_amount
        ]

        organize_acquisition_info(
          search_by(
            fact, fields, acquisition_dimensions, conditions,
            groups: :stock_age_range,
            orders: "acquisition_amount DESC NULLS LAST"
          ),
          :stock_age_range
        )
      end

      def out_of_stock_info(conditions)
        fact = Dw::OutOfStockFact.state_out_of_stock.current

        fields = [
          stock_age_range_sql,
          Fields.car_gross_profit,
          Fields.out_stock_count,
          Fields.out_stock_amount
        ]

        organize_out_of_stock_info(
          search_by(
            fact, fields, out_of_stock_dimensions, conditions,
            groups: :stock_age_range,
            orders: "out_stock_amount DESC NULLS LAST"
          ), :stock_age_range
        )
      end

      def stock_age_range_sql
        <<-SQL.squish!
          CASE
          WHEN dw_car_dimensions.stock_age >= 0 AND dw_car_dimensions.stock_age < 10 THEN '0-10天'
          WHEN dw_car_dimensions.stock_age >= 10 AND dw_car_dimensions.stock_age < 20 THEN '10-20天'
          WHEN dw_car_dimensions.stock_age >= 20 AND dw_car_dimensions.stock_age < 30 THEN '20-30天'
          WHEN dw_car_dimensions.stock_age >= 30 AND dw_car_dimensions.stock_age < 40 THEN '30-40天'
          WHEN dw_car_dimensions.stock_age >= 40 AND dw_car_dimensions.stock_age < 50 THEN '40-50天'
          WHEN dw_car_dimensions.stock_age >= 50 AND dw_car_dimensions.stock_age < 60 THEN '50-60天'
          WHEN dw_car_dimensions.stock_age >= 60 THEN '>=60天'
          ELSE '无收购时间'
          END AS stock_age_range
        SQL
      end
    end
  end
end
