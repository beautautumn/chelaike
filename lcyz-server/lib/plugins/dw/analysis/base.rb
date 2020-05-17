module Dw
  module Analysis
    class Base
      USER_FIELDS = %w(id name username email phone shop_id avatar first_letter).freeze

      def initialize(company_id, shop_id: nil)
        @company_id = company_id
        @shop_id = shop_id
      end

      def search_by(fact, fields, dimensions, conditions,
                    groups: Fields.company_id, orders: [])
        fact.select(Array(fields).join(","))
            .joins(dimensions)
            .ransack(conditions).result
            .group(Array(groups).join(","))
            .order(Array(orders).join(","))
            .as_json
      end

      def acquisition_dimensions
        [:acquired_at_dimension, :car_dimension]
      end

      def out_of_stock_dimensions
        [:stock_out_at_dimension, car_dimension: :acquisition_fact]
      end

      def acquired_at_conditions(date, range)
        within_company_condition.tap do |conditions|
          if range.to_s == "day"
            conditions[:acquired_at_dimension_acquired_at_date_eq] = date.to_date
          else
            conditions[:acquired_at_dimension_acquired_at_year_eq] = date.year
            conditions[:acquired_at_dimension_acquired_at_month_eq] = date.month
          end

          conditions[:car_dimension_shop_id_eq] = @shop_id if @shop_id.present?
        end
      end

      def stock_out_at_conditions(date, range)
        within_company_condition.tap do |conditions|
          if range.to_s == "day"
            conditions[:stock_out_at_dimension_stock_out_at_eq] = date.to_date
          else
            conditions[:stock_out_at_dimension_stock_out_at_year_eq] = date.year
            conditions[:stock_out_at_dimension_stock_out_at_month_eq] = date.month
          end

          conditions[:car_dimension_shop_id_eq] = @shop_id if @shop_id.present?
        end
      end

      def within_company_condition
        { car_dimension_company_id_eq: @company_id }
      end

      def user_fields
        USER_FIELDS.map { |field| "users.#{field}" }
      end

      def organize_acquisition_info(result, column)
        cars_total_count = 0
        total_acquisition_amount = 0

        result.each do |record|
          cars_total_count += record.fetch("acquisition_count")
          total_acquisition_amount += record.fetch("acquisition_amount").to_f
        end

        result.map do |record|
          acquisition_count = record.fetch("acquisition_count").to_i
          acquisition_amount = record.fetch("acquisition_amount").to_f

          {
            column => record.fetch(column.to_s),
            acquisition_count: acquisition_count,
            acquisition_amount: acquisition_amount,
            cars_count_proportion: Util::Math::Percentage.execute(
              acquisition_count, cars_total_count
            ),
            acquisition_amount_proportion: Util::Math::Percentage.execute(
              acquisition_amount, total_acquisition_amount
            ),
            average_acquisition_amount: (
              acquisition_amount / acquisition_count
            ).round(2)
          }
        end
      end

      def organize_out_of_stock_info(result, column)
        cars_total_count = 0
        total_out_stock_amount = 0

        result.each do |record|
          cars_total_count += record.fetch("out_stock_count")
          total_out_stock_amount += record.fetch("out_stock_amount").to_f
        end

        result.map do |record|
          out_stock_count = record.fetch("out_stock_count").to_i
          out_stock_amount = record.fetch("out_stock_amount").to_f
          gross_profit = record.fetch("car_gross_profit").to_f

          {
            column => record.fetch(column.to_s),
            out_stock_count: out_stock_count,
            out_stock_amount: out_stock_amount,
            cars_count_proportion: Util::Math::Percentage.execute(
              out_stock_count, cars_total_count
            ),
            out_stock_amount_proportion: Util::Math::Percentage.execute(
              out_stock_amount, total_out_stock_amount
            ),
            average_out_stock_amount: (out_stock_amount / out_stock_count).round(2),
            gross_profit: (gross_profit / out_stock_count).round(2),
            gross_profit_rate: self.class.gross_profit_rate(
              gross_profit, out_stock_amount
            )
          }
        end
      end

      def self.gross_profit_rate(gross_profit, out_stock_amount)
        Util::Math::Percentage.execute(gross_profit, out_stock_amount)
      end

      def in_stock_by_time_car_ids(time)
        car_ids_by_scope { |scope| scope.in_stock_by_time(time) }
      end

      def stock_by_month_car_ids(date)
        car_ids_by_scope do |scope|
          scope.stock_by_month(date.beginning_of_month, date.end_of_month)
        end
      end

      def current_in_stock_car_ids
        car_ids_by_scope(&:state_in_stock_scope)
      end

      private

      def car_ids_by_scope
        scope = yield(::Car.where(company_id: @company_id)).select(:id)

        return scope.pluck(:id) if @shop_id.blank?

        scope.where(shop_id: @shop_id).pluck(:id)
      end
    end
  end
end
