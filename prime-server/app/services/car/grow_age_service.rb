class Car < ActiveRecord::Base
  class GrowAgeService
    def execute
      Car.transaction do
        update_unfinished_cars

        update_finished_cars
      end
    end

    private

    def update_unfinished_cars
      Car.where.not(state: Car.state_finished).includes(
        :occurred_state_histories, :car_dimension
      ).find_each do |car|
        stock_age_days = car.send(:count_stock_age_days)
        age = car.send(:count_age)

        car.update_columns(
          stock_age_days: stock_age_days,
          age: age,
          states_statistic: car.send(:count_states_statistic)
        )

        Dw::CarDimension.where(car_id: car.id).update_all(
          stock_age: stock_age_days,
          age: age
        )
      end
    end

    def update_finished_cars
      Car.where(state: Car.state_finished).find_each do |car|
        stock_out_at = car.stock_out_at

        next if stock_out_at.blank?

        car.update_columns(
          stock_age_days: car.send(:count_stock_age_days, stock_out_at)
        )
      end
    end
  end
end
