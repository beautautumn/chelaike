module Dw
  module Analysis
    class StockOutMode < Base
      def out_of_stock_info(conditions)
        fact = Dw::OutOfStockFact.state_out_of_stock.current

        fields = [
          mode_sql,
          Fields.out_stock_count,
          Fields.out_stock_amount
        ]

        organize_by_types(
          search_by(
            fact, fields, out_of_stock_dimensions, conditions,
            groups: "dw_out_of_stock_facts.mode"
          )
        )
      end

      # rubocop:disable Metrics/MethodLength
      def organize_by_types(result)
        modes = []
        cars_total_count = 0
        total_out_stock_amount = 0

        result.each do |record|
          cars_total_count += record.fetch("out_stock_count")
          total_out_stock_amount += record.fetch("out_stock_amount").to_f
        end

        detail = {}.tap do |hash|
          result.each do |record|
            mode = record.fetch("mode")
            out_stock_count = record.fetch("out_stock_count")
            out_stock_amount = record.fetch("out_stock_amount").to_f

            modes << mode

            hash[mode] = {
              out_stock_amount: out_stock_amount,
              out_stock_count: out_stock_count,
              cars_count_proportion: Util::Math::Percentage.execute(
                out_stock_count, cars_total_count
              ),
              out_stock_amount_proportion: Util::Math::Percentage.execute(
                out_stock_amount, total_out_stock_amount
              )
            }
          end
        end

        {
          detail: detail,
          modes: modes,
          cars_total_count: cars_total_count,
          total_out_stock_amount: total_out_stock_amount
        }
      end
      # rubocop:enable Metrics/MethodLength

      def mode_sql
        <<-SQL.squish!
          CASE
          WHEN dw_out_of_stock_facts.mode IS NULL THEN 'others'
          ELSE dw_out_of_stock_facts.mode
          END AS mode
        SQL
      end
    end
  end
end
