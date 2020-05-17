namespace :car do
  desc "增加所有在库车辆的库龄"
  task grow_age: :environment do
    Car::GrowAgeService.new.execute
  end

  desc "确保车辆的数据仓库的脚本被运行，再跑一次"
  task ensure_etl: :environment do
    Car.where("updated_at >= ?", Time.zone.now.beginning_of_month)
       .find_each(batch_size: 1000) do |car|
      EtlCarWorker.perform_async(car.id)
    end
  end
end
