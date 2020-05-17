module Maintenance
  class FetchService
    def initialize(vin, current_user, token, options = { action: :new })
      @vin = vin # 可能是vin码，也可能是图片模式里图片地址
      @current_user = current_user
      @action = options[:action]
      @record = options[:record]
      @is_image = options[:is_image]

      @vin.upcase! if @vin.present? && @is_image.blank?

      if options[:car_id].present?
        @car_id = options[:car_id]
        @car = Car.find_by(id: options[:car_id])
      else
        @car = Car.find_by(company_id: current_user.company_id, vin: vin)
        @car_id = @car.id if @car
      end
      @token = token
      @engine = options[:engine]
      @license_plate = options[:license_plate]
      @token_price = MaintenanceRecord.unit_price
    end

    def execute
      case @action
      when :new
        fetch
      when :refetch
        vendor_process
        update_current_record
        @record.set_timeout_worker
      end
    rescue StandardError => e
      generate_operation_record(false, e.message)
      raise e
    end

    private

    def fetch
      if !@is_image && record_hub
        generate_new_record(:unchecked, record_hub)
        decrease_token
        generate_operation_record(true, record_hub.order_message) if record_hub.notify_success?
      else
        vendor_process
        generate_new_record(:generating, @new_hub)
        decrease_token
      end
    end

    def decrease_token
      service = TokenService::Payout.new(@token)
      service.pay(action_type: :maintenance_query,
                  subject: @record,
                  user: @current_user,
                  amount: @record.token_price)
    end

    def record_hub
      time = Time.zone.now - MaintenanceRecordHub::EXPERATION
      @_hub ||= MaintenanceRecordHub.notify_success
                                    .where(vin: @vin)
                                    .where("created_at >= ?", time)
                                    .order(created_at: :desc).first
    end

    def vendor_process
      @new_hub = CheJianDing.process(
        vin: @vin, engine: @engine,
        license_plate: @license_plate,
        is_image: @is_image
      )
    end

    def generate_new_record(state, hub)
      attr = {
        car_id: @car_id,
        license_plate: @license_plate,
        engine: @engine,
        token_price: @token_price,
        maintenance_record_hub_id: hub.id,
        company_id: @current_user.company_id,
        shop_id: @current_user.shop_id,
        user_name: @current_user.name,
        last_fetch_by: @current_user.id,
        last_fetch_at: Time.zone.now,
        state: state
      }

      if @is_image
        attr[:vin_image] = @vin
      else
        attr[:vin] = @vin
      end

      @record = MaintenanceRecord.create!(attr)
    end

    # 记录hub_id，如果更新失败，重新使用原有的hub_id
    # peter: 如果更新失败的话，抛出异常，不会进入下面逻辑的啊
    def update_current_record
      old_hub = @record.maintenance_record_hub
      last_maintenance_record_hub_id = old_hub.notify_success? ? old_hub.id : nil
      @record.update!(maintenance_record_hub_id: @new_hub.id,
                      user_name: @current_user.name,
                      token_price: @token_price,
                      pre_token_price: @record.token_price,
                      last_fetch_by: @current_user.id,
                      last_fetch_at: Time.zone.now,
                      last_maintenance_record_hub_id: last_maintenance_record_hub_id,
                      state: :updating)

      decrease_token
    end

    def generate_operation_record(success, message)
      case @action
      when :new
        info = success ? "【车鉴定】查询成功。" : "【车鉴定】查询失败，#{message}"
      when :refetch
        info = success ? "【车鉴定】查询成功。" : "【车鉴定】更新失败，#{message}"
      end
      type = success ? :maintenance_fetch_success : :maintenance_fetch_fail
      OperationRecord.create!(operation_record_type: type,
                              user_id: @current_user.id,
                              shop_id: @current_user.shop_id,
                              company_id: @current_user.company_id,
                              messages: { action: @action,
                                          car_id: @car_id,
                                          maintenance_record_id: @record.try(:id),
                                          title: "维保查询",
                                          car_name: @car.try(:system_name),
                                          vin: @vin,
                                          result: false,
                                          info: info })
    end
  end
end
