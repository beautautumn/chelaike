class Car < ActiveRecord::Base
  class RelativeStatisticService
    attr_reader :user, :car

    def initialize(user, car)
      @user = user
      @car = car
    end

    def execute
      {
        intentions_count: intentions.size,
        checked_intentions_count: checked_intentions.size,
        similar_in_stock_count: similar_in_stock.size,
        similar_sold_count: similar_sold.size
      }
    end

    def intentions
      intentions_formula(intentions_scope)
    end

    def intentions_formula(super_scope)
      return Intention.none if car.brand_name.blank?

      scope = super_scope.where(intention_type: :seek)
                         .state_unfinished_scope
                         .where(
                           "?::jsonb <@ ANY(intentions.seeking_cars)",
                           Util::SQL.to_jsonb(:brand_name, car.brand_name)
                         )

      if car.series_name.present?
        scope = scope.where(
          "?::jsonb <@ ANY(intentions.seeking_cars) OR ?::jsonb <@ ANY(intentions.seeking_cars)",
          Util::SQL.to_jsonb(:series_name, ""),
          Util::SQL.to_jsonb(:series_name, car.series_name)
        )
      end

      if car.show_price_cents.present?
        show_price_cents_sql = <<-SQL.squish!
          (intentions.minimum_price_cents IS NULL AND intentions.maximum_price_cents IS NULL) OR
          (intentions.minimum_price_cents IS NULL AND :price <= intentions.maximum_price_cents ) OR
          (:price >= intentions.minimum_price_cents AND intentions.maximum_price_cents IS NULL) OR
          (:price >= intentions.minimum_price_cents AND :price <= intentions.maximum_price_cents)
        SQL

        scope = scope.where(
          show_price_cents_sql, price: car.show_price_cents
        )
      end

      scope
    end

    def checked_intentions
      return IntentionPushCar.none if car.allied?(user)

      IntentionPushCar.uniq.joins(:intention).where(car_id: car.id)
    end

    def similar_in_stock
      similar_scope.state_in_stock_scope
    end

    def similar_sold
      similar_scope.state_out_of_stock_scope
    end

    def intentions_scope
      @_intentions_scope ||= Intention.where(assignee_id: related_users)
    end

    def related_users
      @_related_users ||= User::IntentionService.related_users(user)
    end

    def similar_scope
      Car.where(
        company_id: user.company_id,
        series_name: car.series_name
      )
    end
  end
end
