module Dw
  module Analysis
    class Age < Base
      def stock_info(conditions)
        fact = Dw::AcquisitionFact

        fields = [
          age_range_sql,
          Fields.acquisition_count,
          Fields.acquisition_amount
        ]

        organize_acquisition_info(
          search_by(
            fact, fields, acquisition_dimensions, conditions,
            groups: :age_range,
            orders: "acquisition_amount DESC NULLS LAST"
          ),
          :age_range
        )
      end

      def out_of_stock_info(conditions)
        fact = Dw::OutOfStockFact.state_out_of_stock.current

        fields = [
          age_range_sql,
          Fields.car_gross_profit,
          Fields.out_stock_count,
          Fields.out_stock_amount
        ]

        organize_out_of_stock_info(
          search_by(
            fact, fields, out_of_stock_dimensions, conditions,
            groups: :age_range,
            orders: "out_stock_amount DESC NULLS LAST"
          ), :age_range
        )
      end

      def age_range_sql
        <<-SQL.squish!
          CASE
          WHEN dw_car_dimensions.age >= 0 AND dw_car_dimensions.age < 365 THEN '1年以内'
          WHEN dw_car_dimensions.age >= 365 AND dw_car_dimensions.age < 730 THEN '1-2年'
          WHEN dw_car_dimensions.age >= 730 AND dw_car_dimensions.age < 1095 THEN '2-3年'
          WHEN dw_car_dimensions.age >= 1095 AND dw_car_dimensions.age < 1825 THEN '3-5年'
          WHEN dw_car_dimensions.age >= 1825 AND dw_car_dimensions.age < 2920 THEN '5-8年'
          WHEN dw_car_dimensions.age >= 2920 AND dw_car_dimensions.age < 3650 THEN '8-10年'
          WHEN dw_car_dimensions.age >= 3650 THEN '10年以上'
          ELSE '无上牌日期'
          END AS age_range
        SQL
      end
    end
  end
end
