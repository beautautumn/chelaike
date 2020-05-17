namespace :car do
  desc "增加所有在库车辆的库龄"
  task grow_age: :environment do
    Car::GrowAgeService.new.execute
  end

  desc "把库里所有车辆的vin码大写"
  task upcase_vin: :environment do
    Car.all.each do |car|
      car.update_columns(vin: car.vin.try(:upcase))
    end
  end
end
