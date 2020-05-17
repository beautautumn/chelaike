module AcquisitionCarInfoService
  class Assign
    def initialize(user, acquisition_car_info)
      @user = user
      @info = acquisition_car_info
    end

    def assign_to(acquirer_id)
      @info.update(acquirer_id: acquirer_id, state: "init")
      create_operation_record(acquirer_id)
    end

    private

    def create_operation_record(acquirer_id)
      acquirer = User.find(acquirer_id)
      @info.operation_records.create!(
        user: acquirer,
        company_id: acquirer.company_id,
        operation_record_type: :assigned_acquisition_car_info,
        shop_id: acquirer.shop_id,
        messages: {
          acquisition_car_info_id: @info.id,
          intention_id: @info.id,
          user_name: @user.name,
          title: "新评估待跟进"
        },
        user_passport: acquirer.passport.to_h
      )
    end
  end
end
