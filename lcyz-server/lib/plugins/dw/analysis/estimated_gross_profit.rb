module Dw
  module Analysis
    class EstimatedGrossProfit < Base
      def stock_info(conditions)
        fact = Dw::AcquisitionFact

        fields = [
          estimated_gross_profit_sql,
          Fields.acquisition_count,
          Fields.acquisition_amount,
          Fields.average_estimated_gross_profit,
          Fields.average_estimated_gross_profit_rate
        ]

        organize_acquisition_info(
          search_by(
            fact, fields, acquisition_dimensions, conditions,
            groups: [:estimated_gross_profit, "dw_acquisition_facts.acquisition_type"],
            orders: "acquisition_count DESC NULLS LAST"
          )
        )
      end

      # rubocop:disable Metrics/MethodLength
      def organize_acquisition_info(result)
        totals = count_totals(result)

        result.group_by { |record| record.fetch("estimated_gross_profit") }
              .map do |estimated_gross_profit, records|
                acquisition_count = 0
                acquisition_amount = 0.0
                total_estimated_gross_profit = 0.0
                total_estimated_gross_profit_rate = 0.0

                records.each do |record|
                  acquisition_count += record.fetch("acquisition_count").to_i
                  acquisition_amount += record.fetch("acquisition_amount").to_f
                  total_estimated_gross_profit += record.fetch(
                    "average_estimated_gross_profit"
                  ).to_f
                  total_estimated_gross_profit_rate += record.fetch(
                    "average_estimated_gross_profit_rate"
                  ).to_f
                end

                average_estimated_gross_profit = (
                  total_estimated_gross_profit / acquisition_count
                ).to_f
                average_estimated_gross_profit_rate = (
                  total_estimated_gross_profit_rate / acquisition_count
                ).to_f

                {
                  estimated_gross_profit: estimated_gross_profit,
                  acquisition_count: acquisition_count,
                  acquisition_amount: acquisition_amount,
                  cars_count_proportion: Util::Math::Percentage.execute(
                    acquisition_count, totals.fetch(:cars_total_count)
                  ),
                  acquisition_amount_proportion: Util::Math::Percentage.execute(
                    acquisition_amount, totals.fetch(:total_acquisition_amount)
                  ),
                  average_estimated_gross_profit: average_estimated_gross_profit.round(2),
                  average_estimated_gross_profit_rate: Util::Math::Percentage.show(
                    average_estimated_gross_profit_rate.round(4)
                  )
                }
              end
      end
      # rubocop:enable Metrics/MethodLength

      def count_totals(result)
        cars_total_count = 0
        total_acquisition_amount = 0

        result.each do |record|
          cars_total_count += record.fetch("acquisition_count").to_i
          total_acquisition_amount += record.fetch("acquisition_amount").to_f
        end

        {
          cars_total_count: cars_total_count,
          total_acquisition_amount: total_acquisition_amount
        }
      end

      def estimated_gross_profit_sql
        <<-SQL.squish!
          CASE
          WHEN dw_car_dimensions.estimated_gross_profit_cents < 0 THEN '负毛利'
          WHEN dw_car_dimensions.estimated_gross_profit_cents >= 0
            AND dw_car_dimensions.estimated_gross_profit_cents < 1000000 THEN '1万以内'
          WHEN dw_car_dimensions.estimated_gross_profit_cents >= 1000000
            AND dw_car_dimensions.estimated_gross_profit_cents < 5000000 THEN '1-5万'
          WHEN dw_car_dimensions.estimated_gross_profit_cents >= 5000000
            AND dw_car_dimensions.estimated_gross_profit_cents < 10000000 THEN '5-10万'
          WHEN dw_car_dimensions.estimated_gross_profit_cents >= 10000000 THEN '10万以上'
          ELSE '无销售底价'
          END AS estimated_gross_profit
        SQL
      end
    end
  end
end
