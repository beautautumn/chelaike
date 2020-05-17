class Alliance < ActiveRecord::Base
  class CarsCreatedStatisticService
    def initialize
      @midday = Time.zone.now.noon
      @at_noon_yesterday = @midday - 1.day
    end

    def execute
      company_ids = companies.pluck(:id)

      Alliance.joins(:alliance_company_relationships)
              .where("alliance_company_relationships.company_id IN (?)", company_ids)
              .find_each do |alliance|
                execute_statistic(alliance).each do |assignee_id, hash|
                  company_id = hash.delete(:company_id)

                  create_operation_record(alliance, assignee_id, company_id, hash)
                end
              end
    end

    # {
    #   `assignee_id` => {
    #     company_id: `company_id`,
    #     `car_id` => [`intention_id1`, `intention_id2`]
    #   }
    # }
    def execute_statistic(alliance)
      cars = cars_scope(alliance.cars)

      return if cars.to_a.empty? == 0
      alliance_company_ids = alliance.company_ids

      {}.tap do |hash|
        cars.each do |car|
          intention_scope = Intention.where(
            company_id: alliance_company_ids - [car.company_id]
          )

          Car::RelativeStatisticService
            .new(User::Anonymous.new, car)
            .intentions_formula(intention_scope)
            .select(:id, :assignee_id, :company_id)
            .uniq
            .group_by(&:assignee_id)
            .each do |assignee_id, intentions_array|
              hash[assignee_id] = {
                company_id: intentions_array.first.company_id,
                car.id => intentions_array.map(&:id)
              }
            end
        end
      end
    end

    def create_operation_record(alliance, assignee_id, company_id, hash)
      car_ids = hash.keys
      intentions = hash.values.flatten

      operation_record = OperationRecord.create!(
        user_id: assignee_id,
        company_id: company_id,
        operation_record_type: :alliance_cars_created_statistic,
        messages: {
          alliance_name: alliance.name,
          result: hash,
          title: "联盟新增入库",
          car_ids: car_ids,
          cars_count: car_ids.size,
          intentions: intentions,
          intentions_count: intentions.size
        }
      )

      StatisticMessageWorker.perform_async(operation_record.id)
    end

    def companies
      Company.where(id: cars_scope.select(:company_id).uniq)
    end

    def cars_scope(super_scope = Car)
      super_scope.where(
        "cars.created_at > ? AND cars.created_at <= ?", @at_noon_yesterday, @midday
      )
    end
  end
end
