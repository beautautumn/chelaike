# 检测车辆新增融资状态
module CheRongYi
  class CheckAccreditedService
    attr_reader :cars, :vin_errors, :images_errors, :key_count_errors,
                :driving_license_image_errors, :registration_license_image_errors,
                :insurance_image_errors, :first_check_errors,
                :estimate_errors, :mileage_errors

    def initialize(car_ids)
      @cars = ::Car.where(id: car_ids)

      @vin_errors = { cars: [] }
      @key_count_errors = { cars: [] }
      @driving_license_image_errors = { cars: [] }
      @registration_license_image_errors = { cars: [] }
      @insurance_image_errors = { cars: [] }
      @first_check_errors = { cars: [] }
      @estimate_errors = { cars: [] }
      @mileage_errors = { cars: [] }
    end

    # 每个车辆去进行检测，把出错信息集中返回
    def check(replaced_car_ids)
      return { state: "duplicate", message: "有车辆已经申请融资，不能重复申请" } if
        @cars.inject(false) { |a, e| a || e.loan_status_loan? }

      return { state: "error", messages: "error" } unless
        @cars.inject(true) { |a, e| a && e.acquisition_transfer }

      @cars.each do |car|
        check_detail(car)
      end

      # check_estimate(replaced_car_ids) if replaced_car_ids

      error_messages = compose_errors
      state = compose_errors.map { |m| m.fetch(:state) }.inject(true) do |acc, bool|
        bool && acc
      end

      if state
        { state: "success", message: "" }
      else
        { state: "error", message: error_messages }
      end
    end

    private

    def check_detail(car)
      check_vin(car)
      check_images(car)
      check_key_count(car)
      check_mileage(car)
      # check_first_check(car)
    end

    # 把错误结果拼装一下返回前端
    def compose_errors
      [vin_errors_message, key_count_errors_message,
       driving_license_image_errors_message,
       registration_license_image_errors_message,
       insurance_image_errors_message,
       first_check_errors_message,
       mileage_check_errors_message
      ].select { |message| message[:state] == false }
    end

    def check_vin(car)
      vin = car.vin
      @vin_errors[:cars] << { id: car.id, name: car.system_name } unless vin.present?
    end

    def check_key_count(car)
      transfer_record = car.acquisition_transfer

      key_count = transfer_record.key_count || 0
      state = key_count.try(:>, 1)

      @key_count_errors[:cars] << { id: car.id, name: car.system_name } unless state
    end

    def check_images(car)
      transfer_record = car.acquisition_transfer
      image_locations_hash = {
        driving_license: "行驶证",
        registration_license: "登记证",
        insurance: "保单"
      }

      image_locations_hash.inject([]) do |acc, image_location_arr|
        location = image_location_arr.first
        location_text = image_location_arr.last
        image_exists = transfer_record.images.exists?(location: [location.to_s, location_text])

        instance_variable_get("@#{location}_image_errors")[:cars] << { id: car.id, name: car.system_name } unless image_exists
      end
    end

    def check_first_check(car)
      first_check = car.first_check_appointments.count > 0
      @first_check_errors[:cars] << { id: car.id, name: car.system_name } unless first_check
    end

    def check_mileage(car)
      mileage_check = car.mileage.present?
      @mileage_errors[:cars] << { id: car.id, name: car.system_name } unless mileage_check
    end

    def check_estimate(replaced_car_ids)
      replaced_cars = ::Car.where(id: replaced_car_ids)

      total_cars_estimate = @cars.inject(0) { |acc, car| acc + car.estimate_price_wan } # 替换上来的车辆
      replaced_cars_estimate = replaced_cars.inject(0) { |acc, car| acc + car.estimate_price_wan } # 替换下去的车辆

      state = total_cars_estimate >= replaced_cars_estimate

      @estimate_errors[:cars] << { id: @cars.first.id, name: @cars.first.system_name } unless state
    end

    def vin_errors_message
      {
        item: "车架号正确",
        state: @vin_errors[:cars].count == 0,
        message: "车架号位数不对",
        cars: @vin_errors[:cars]
      }
    end

    def key_count_errors_message
      {
        item: "钥匙≥2",
        state: @key_count_errors[:cars].count == 0,
        message: "钥匙不足2把",
        cars: @key_count_errors[:cars]
      }
    end

    def driving_license_image_errors_message
      {
        item: "行驶证照片",
        state: @driving_license_image_errors[:cars].count == 0,
        message: "行驶证照片未上传",
        cars: @driving_license_image_errors[:cars]
      }
    end

    def registration_license_image_errors_message
      {
        item: "登记证照片",
        state: @registration_license_image_errors[:cars].count == 0,
        message: "登记证照片未上传",
        cars: @registration_license_image_errors[:cars]
      }
    end

    def insurance_image_errors_message
      {
        item: "保单照片",
        state: @insurance_image_errors[:cars].count == 0,
        message: "保单照片未上传",
        cars: @insurance_image_errors[:cars]
      }
    end

    def first_check_errors_message
      {
        item: "初检",
        state: @first_check_errors[:cars].count == 0,
        message: "",
        cars: @first_check_errors[:cars]
      }
    end

    def mileage_check_errors_message
      {
        item: "公里数",
        state: @mileage_errors[:cars].count == 0,
        message: "未填写车辆里程",
        cars: @mileage_errors[:cars]
      }
    end

    def estimate_errors_message
      {
        item: "估值≥原车辆",
        state: @estimate_errors[:cars].count == 0,
        message: "估值小于原车辆",
        cars: @estimate_errors[:cars]
      }
    end
  end
end
