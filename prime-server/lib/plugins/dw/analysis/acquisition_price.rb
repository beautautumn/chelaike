module Dw
  module Analysis
    class AcquisitionPrice < Base
      def stock_info(conditions)
        fact = Dw::AcquisitionFact

        fields = [
          price_range_sql,
          Fields.acquisition_count,
          Fields.acquisition_amount
        ]

        organize_acquisition_info(
          search_by(
            fact, fields, acquisition_dimensions, conditions,
            groups: :price_range,
            orders: "acquisition_amount DESC NULLS LAST"
          ),
          :price_range
        )
      end

      def price_range_sql
        <<-SQL.squish!
          CASE
          WHEN dw_acquisition_facts.acquisition_price_cents < 10000000 THEN '10万以下'
          WHEN dw_acquisition_facts.acquisition_price_cents >= 10000000
            AND dw_acquisition_facts.acquisition_price_cents < 30000000 THEN '10-30万'
          WHEN dw_acquisition_facts.acquisition_price_cents >= 30000000
            AND dw_acquisition_facts.acquisition_price_cents < 50000000 THEN '30-50万'
          WHEN dw_acquisition_facts.acquisition_price_cents >= 50000000
            AND dw_acquisition_facts.acquisition_price_cents < 100000000 THEN '50-100万'
          WHEN dw_acquisition_facts.acquisition_price_cents > 100000000 THEN '100万以上'
          ELSE '无收购价格'
          END AS price_range
        SQL
      end
    end
  end
end
