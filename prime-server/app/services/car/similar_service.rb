class Car < ActiveRecord::Base
  class SimilarService
    attr_reader :scope

    def initialize(scope)
      @scope = scope
    end

    def execute
      scope.select("cars.*", selection_sql)
    end

    def similar_to(car)
      result_scope = scope
      show_price_cents = car.show_price_cents

      if show_price_cents.present?
        minimum_show_price_cents = (show_price_cents * 0.75).to_i
        maximum_show_price_cents = (show_price_cents * 1.25).to_i

        match_prices = <<-SQL.squish!
          cars.show_price_cents >= '#{minimum_show_price_cents}' AND
          cars.show_price_cents <= '#{maximum_show_price_cents}'
        SQL

        first_arr = result_scope.where(match_prices).where(series_name: car.series_name)
        second_arr = result_scope.where(match_prices).where(car_type: car.car_type) if car.car_type?
        third_arr = result_scope.where(match_prices)
      else
        first_arr = result_scope.where(series_name: car.series_name)
        second_arr = result_scope.where(car_type: car.car_type) if car.car_type?
        third_arr = nil
      end

      [first_arr, second_arr, third_arr].flatten.compact.uniq.take(20)
    end

    def selection_sql
      company_ids_sql = scope.pluck(:company_id)
                             .uniq
                             .map { |company_id| "'#{company_id}'" }
                             .join(", ")

      if company_ids_sql.present?
        company_ids_sql = "AND c.company_id IN (#{company_ids_sql})"
      end

      <<-SQL.squish!
        (
          SELECT COUNT(c.id) FROM cars as c
          WHERE (cars.car_type IS NULL OR c.car_type = cars.car_type) AND
          (
            cars.show_price_cents IS NULL OR (
              c.show_price_cents >= cars.show_price_cents * 0.75 AND
              c.show_price_cents <= cars.show_price_cents * 1.25
            )
          ) AND
          (
            (cars.car_type IS NULL AND cars.show_price_cents IS NULL) OR
            (c.brand_name = cars.brand_name AND c.series_name = cars.series_name)
          ) AND c.deleted_at IS NULL
            AND c.sellable = 't'
            AND c.reserved = 'f'
            AND c.state IN ('in_hall', 'preparing', 'shipping', 'loaning', 'transferred')
            #{company_ids_sql}
        ) AS similar_cars_count
      SQL
    end
  end
end
