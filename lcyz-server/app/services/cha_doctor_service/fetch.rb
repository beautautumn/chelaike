module ChaDoctorService
  class Fetch
    class NoEnoughTokenError < StandardError; end
    class InternalError < StandardError; end
    class ExternalError < StandardError; end
    class TokenError < StandardError; end

    attr_accessor :hub, :record

    def initialize(vin, user, car_id: nil)
      @user = user
      @vin = vin
      @car_id = car_id
      @car = Car.find(car_id) if car_id
    end

    def execute(is_image = false)
      if is_image
        check_token! do |token|
          record = init_record(action_type: :new, is_image: true)
          decrease_token(record, token)
        end
      else
        check_token! do |token|
          record = init_record(action_type: :new)
          buy_report(record: record, action: :new, token: token) if check_vin_avaiable?
        end
      end

      self
    end

    def refetch(old_record)
      check_token! do |token|
        record = init_record(action_type: :refetch)
        buy_report(record: record, action: :refetch, token: token)
        old_record.update!(
          last_cha_doctor_record_hub_id: @hub.id,
          state: :updating
        )
      end

      self
    end

    def fire(record, failed = false, info = "")
      @user = User.find(record.user_id)
      if failed # 图片不能识别
        generate_operation_record!(nil, record, :vin_image, info)
        refund_token(record, record.token_price)
        record.update!(state: :vin_image_fail)
      else
        record.update!(vin: @vin,
                       request_at: Time.zone.now # 记录发起时间
                      )
        token = Token.find(record.token_id)
        check_vin_avaiable? &&
          buy_report(record: record, action: :new, token: token, is_image: true)
      end
    end

    private

    def check_token!
      token = Token.get_or_create_token!(@user.company)
      user_token = Token.get_or_create_token!(@user)

      token.with_lock do
        if user_token.balance.to_d >= token_price
          yield user_token
        elsif token.balance.to_d >= token_price && @user.can?("维保报告查询")
          yield token
        else
          raise NoEnoughTokenError
        end
      end
    end

    def token_price
      @_token_price ||= ChaDoctorRecord.unit_price
    end

    def check_vin_avaiable?
      return true if record_hub.present?
      result = ChaDoctorService::API.check_brand(@vin)

      case result.status
      when :success
        return true
      when :internal_error
        raise InternalError, result.message
      when :external_error
        raise ExternalError, result.message
      end
    end

    def record_hub
      @_hub ||= ChaDoctorRecordHub.available_hub(@vin)
    end

    def buy_report(record:, action: :new, token:, is_image: false)
      if record_hub.present? && action == :new
        @hub = record_hub
        associate_record(record_hub, record)
        decrease_token(record, token) unless is_image
        record.update!(state: :unchecked)
        generate_operation_record!(record_hub, record, action)
      else
        vendor_process(record, token, action, is_image)
      end
    end

    def vendor_process(record, token, action, is_image)
      result = ChaDoctorService::API.buy_report(@vin)

      hub = create_record_hub(result)
      @hub = hub
      associate_record(hub, record)

      case result.status
      when :success
        decrease_token(record, token) unless is_image
      else
        process_error(error_type: result.status,
                      is_image: is_image,
                      record: record,
                      hub: hub,
                      action: action,
                      buy_result: result)
      end
    end

    def process_error(error_type:, is_image:, record:, hub:, action:, buy_result:)
      is_image && refund_token(record, record.token_price)
      generate_operation_record!(hub, record, action)

      error_class = {
        internal_error: InternalError,
        external_error: ExternalError
      }.fetch(error_type)

      raise error_class, buy_result.message
    end

    def decrease_token(record, token)
      record.update!(payment_state: :paid)
      service = TokenService::Payout.new(token)
      service.pay(action_type: :maintenance_query,
                  subject: record,
                  user: @user,
                  amount: record.token_price)
    end

    def refund_token(record, price)
      raise TokenError unless record.paying?
      token = Token.find(record.token_id)
      service = TokenService::Income.new(token)
      service.refund(record, price)
      record.update!(payment_state: :refunded)
    end

    def init_record(action_type: :new, is_image: false)
      record = if is_image
                 ChaDoctorRecord.new(
                   company_id: @user.company_id,
                   user_id: @user.id,
                   vin_image: @vin,
                   user_name: @user.name,
                   token_price: token_price,
                   action_type: action_type,
                   payment_state: :unpaid,
                   state: :submitted
                 )
               else
                 ChaDoctorRecord.new(
                   company_id: @user.company_id,
                   user_id: @user.id,
                   vin: @vin,
                   user_name: @user.name,
                   token_price: token_price,
                   action_type: action_type,
                   payment_state: :unpaid
                 )
               end
      record.save!
      generate_reminder_record(record) if is_image
      record
    end

    def associate_record(hub, record)
      success = hub.order_state.success?

      state = success ? :generating : :generating_fail

      record.update!(
        cha_doctor_record_hub_id: hub.id,
        last_cha_doctor_record_hub_id: hub.id,
        state: state
      )
    end

    def create_record_hub(buy_result)
      state = buy_result.status == :success ? :success : :failed
      hub = ChaDoctorRecordHub.new(
        vin: @vin,
        sent_at: Time.zone.now,
        order_state: state,
        order_status: buy_result.code,
        order_message: buy_result.message,
        order_id: buy_result.data
      )

      hub.save!
      hub
    end

    def generate_operation_record!(hub, record, action, info = "")
      is_success = hub.try(:order_state) == :success
      message = hub.try(:order_message) || info

      info = operation_record_info(action, is_success, message, record)
      type = case action
             when :vin_image
               :vin_image_fail
             else
               is_success ? :maintenance_fetch_success : :maintenance_fetch_fail
             end

      OperationRecord.create!(operation_record_type: type,
                              user_id: @user.id,
                              shop_id: @user.shop_id,
                              company_id: @user.company_id,
                              messages: { action: action,
                                          car_id: @car_id,
                                          cha_doctor_record_id: record.try(:id),
                                          title: "维保查询",
                                          car_name: @car.try(:system_name),
                                          vin: @vin,
                                          result: false,
                                          platform_name: record.platform_name,
                                          token_price: record.token_price,
                                          info: info,
                                          msg: message })
    end

    def operation_record_info(action, is_success, message, record)
      case action
      when :new
        is_success ? "【查博士】查询成功。" : "【查博士】查询失败，#{message}"
      when :refetch
        is_success ? "【查博士】更新成功。" : "【查博士】更新失败，#{message}"
      when :vin_image
        vin_image_error_text(message, record)
      end
    end

    def vin_image_error_text(message, record)
      msg = message.presence || "vin码不能识别, 请重新上传"
      "#{@car.try(:system_name)}<br/>【查博士】"\
                "#{msg}，#{record.token_price}车币已退回。"
    end

    def generate_reminder_record(record)
      xiaocheche = User.find_by(name: "小车车")

      OperationRecord.create!(operation_record_type: :vin_image_request,
                              user_id: xiaocheche.id,
                              shop_id: xiaocheche.shop_id,
                              company_id: xiaocheche.company_id,
                              messages: { car_id: @car_id,
                                          cha_doctor_record_id: record.try(:id),
                                          platform: :cha_doctor,
                                          record_id: record.try(:id),
                                          title: "VIN码识别",
                                          car_name: @car.try(:system_name),
                                          company_name: @car.try(:company).try(:name) })
    end
  end
end
