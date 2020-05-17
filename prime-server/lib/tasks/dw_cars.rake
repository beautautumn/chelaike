namespace :dw_cars do
  desc "把本月里未同步到数据仓库里的车辆统一同步一次"
  task sync: :environment do
    start_time = Date.today.beginning_of_month.beginning_of_day
    end_time = Date.today.end_of_month.end_of_day

    default_car_scope = Car.where("updated_at between ? and ?", start_time, end_time)
    dw_cars_scope = Dw::CarDimension.where("updated_at between ? and ?", start_time, end_time)
    missing_cars = default_car_scope.where.not(id: dw_cars_scope.pluck(:car_id))

    missing_cars.each do |car|
      EtlCarWorker.perform_async(car.id)
    end
  end
end
