module Dw
  module Analysis
    class ClosingCost < Base
      def out_of_stock_info(conditions)
        fact = Dw::OutOfStockFact.state_out_of_stock.current

        fields = [
          price_range_sql,
          Fields.car_gross_profit,
          Fields.out_stock_count,
          Fields.out_stock_amount
        ]

        organize_out_of_stock_info(
          search_by(
            fact, fields, out_of_stock_dimensions, conditions,
            groups: :price_range,
            orders: "out_stock_amount DESC NULLS LAST"
          ), :price_range
        )
      end

      def price_range_sql
        <<-SQL.squish!
          CASE
          WHEN dw_out_of_stock_facts.closing_cost_cents < 10000000 THEN '10万以下'
          WHEN dw_out_of_stock_facts.closing_cost_cents >= 10000000
            AND dw_out_of_stock_facts.closing_cost_cents < 30000000 THEN '10-30万'
          WHEN dw_out_of_stock_facts.closing_cost_cents >= 30000000
            AND dw_out_of_stock_facts.closing_cost_cents < 50000000 THEN '30-50万'
          WHEN dw_out_of_stock_facts.closing_cost_cents >= 50000000
            AND dw_out_of_stock_facts.closing_cost_cents < 100000000 THEN '50-100万'
          WHEN dw_out_of_stock_facts.closing_cost_cents > 100000000 THEN '100万以上'
          ELSE '无成交价'
          END AS price_range
        SQL
      end
    end
  end
end
