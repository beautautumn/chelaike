module Dw
  module Analysis
    class Fields
      # 收购总金额
      def self.acquisition_amount(alias_name: __method__, unit: :wan)
        <<-SQL.squish!
          ROUND(
            (
              SUM(dw_acquisition_facts.acquisition_price_cents
            ) * 1.0 / #{Util::ExchangeRate.cents_by_unit(unit)}) , 2
          ) AS #{alias_name}
        SQL
      end

      # 收购(入库)总量
      def self.acquisition_count(alias_name: __method__)
        <<-SQL.squish!
          COUNT(
            dw_acquisition_facts.id
          ) AS #{alias_name}
        SQL
      end

      # 公司ID
      def self.company_id
        "dw_car_dimensions.company_id".freeze
      end

      # 品牌
      def self.brand_name
        "dw_car_dimensions.brand_name".freeze
      end

      # 车系
      def self.series_name
        "dw_car_dimensions.series_name".freeze
      end

      # 收购类型
      def self.acquisition_type
        "dw_acquisition_facts.acquisition_type".freeze
      end

      def self.out_stock_count_rule
        <<-SQL.squish!
          COUNT(dw_out_of_stock_facts.id)
        SQL
      end

      # 出库总量
      def self.out_stock_count
        <<-SQL.squish!
          #{out_stock_count_rule} AS out_stock_count
        SQL
      end

      # 出库成交均价
      def self.averge_closing_cost_price(alias_name: __method__, unit: :wan)
        <<-SQL.squish!
          ROUND(
            AVG(
              dw_out_of_stock_facts.closing_cost_cents
              + dw_out_of_stock_facts.refund_price_cents
            ) * 1.0 / #{Util::ExchangeRate.cents_by_unit(unit)}, 2
          ) AS #{alias_name}
        SQL
      end

      # 出库成交总金额
      def self.out_stock_amount(alias_name: __method__, unit: :wan)
        <<-SQL.squish!
          ROUND(
            SUM(
              dw_out_of_stock_facts.closing_cost_cents
              + dw_out_of_stock_facts.refund_price_cents
            ) * 1.0 / #{Util::ExchangeRate.cents_by_unit(unit)}, 2
          ) AS #{alias_name}
        SQL
      end

      # 平均展厅价格
      def self.averge_show_price(alias_name: __method__, unit: :wan)
        <<-SQL.squish!
          ROUND(
            AVG(
              dw_car_dimensions.show_price_cents
            ) * 1.0 / #{Util::ExchangeRate.cents_by_unit(unit)}, 2
          ) AS #{alias_name}
        SQL
      end

      # 车辆毛利 = (分成价格 || 成交价格 + 收购退车价格) - (
      #   收购价格 + 整备费用 + 佣金 + 其他费用 +
      #   销售过户提档费 + 销售过户过户费 + 收购过户提档费 + 收购过户过户费
      # )
      # dw_out_of_stock_facts.refund_price_cents 收购退车价格(ignore)
      def self.car_gross_profit_rule
        <<-SQL.squish!
          SUM(
            (
              CASE dw_acquisition_facts.acquisition_type
              WHEN 'consignment' THEN
                dw_out_of_stock_facts.carried_interest_cents
              ELSE
                dw_out_of_stock_facts.closing_cost_cents
              END
                + dw_out_of_stock_facts.refund_price_cents
                - dw_acquisition_facts.acquisition_price_cents
                - dw_car_dimensions.prepare_items_total_amount_cents
                - dw_out_of_stock_facts.commission_cents
                - dw_out_of_stock_facts.other_fee_cents
                - dw_car_dimensions.sale_total_transfer_fee_cents
                - dw_car_dimensions.acquisition_total_transfer_fee_cents
            )
          )
        SQL
      end

      # 车辆毛利
      def self.car_gross_profit(alias_name: __method__, unit: :wan)
        <<-SQL.squish!
          ROUND(
            #{car_gross_profit_rule} * 1.0 / #{Util::ExchangeRate.cents_by_unit(unit)}, 2
          ) AS #{alias_name}
        SQL
      end

      # 车辆平均预期毛利
      def self.average_estimated_gross_profit(alias_name: __method__, unit: :wan)
        <<-SQL.squish!
          (
            SELECT
              ROUND(
                AVG(
                  dw_car_dimensions.estimated_gross_profit_cents
                ) * 1.0 / #{Util::ExchangeRate.cents_by_unit(unit)}, 2
              )
            FROM dw_car_dimensions
            WHERE dw_acquisition_facts.acquisition_type != 'consignment'
          ) AS #{alias_name}
        SQL
      end

      # 车辆预计毛利总和
      def self.estimated_gross_profit_amount(alias_name: __method__, unit: :wan)
        <<-SQL.squish!
          ROUND(
            SUM(dw_car_dimensions.estimated_gross_profit_cents) * 1.0
              / #{Util::ExchangeRate.cents_by_unit(unit)}, 2
          ) AS #{alias_name}
        SQL
      end

      # 车辆平均预期毛利率
      def self.average_estimated_gross_profit_rate(alias_name: __method__)
        <<-SQL.squish!
          AVG(dw_car_dimensions.estimated_gross_profit_rate) AS #{alias_name}
        SQL
      end

      # 平均车辆毛利
      def self.average_gross_profit(unit: :wan)
        <<-SQL.squish!
          ROUND(
            #{car_gross_profit_rule} * 1.0
            / #{out_stock_count_rule}
            / #{Util::ExchangeRate.cents_by_unit(unit)}, 2
          ) AS average_gross_profit
        SQL
      end
    end
  end
end
