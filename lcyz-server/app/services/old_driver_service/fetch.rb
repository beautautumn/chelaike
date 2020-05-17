# 老司机查询方法，处理业务逻辑
module OldDriverService
  class Fetch
    class NoEnoughTokenError < StandardError; end
    class InternalError < StandardError; end
    class ExternalError < StandardError; end
    class TokenError < StandardError; end

    attr_accessor :user, :vin, :engine_num, :license_no, :id_numbers

    def initialize(user:, vin:, engine_num: "", license_no: "", id_numbers: "")
      @user = user
      @vin = vin
      @engine_num = engine_num
      @license_no = license_no
      @id_numbers = id_numbers
    end

    def fetch
      check_token! do |token|
        record = init_record(action_type: :new)
        buy_report(record: record, action: :new, token: token)
      end
    end

    def refetch(old_record)
      check_token! do |token|
        # record = init_record(action_type: :refetch)
        old_record.update!(state: :updating, action_type: :refetch)
        buy_report(record: old_record, action: :refetch, token: token)
      end
    end

    # 只给后台使用，不扣款，不生成订单
    def only_fetch
      # test vin: LJDGAA228E0410969
      record = init_record(action_type: :new)
      buy_report_without_token(record)
    end

    private

    def decrease_token(record, token)
      record.update!(payment_state: :paid)
      service = TokenService::Payout.new(token)
      service.pay(action_type: :insurance_query,
                  subject: record,
                  user: @user,
                  amount: record.token_price)
    end

    def buy_report_without_token(record)
      result = OldDriverService::API.new(vin: @vin,
                                         engine_num: @engine_num,
                                         id_number: @id_numbers,
                                         license_no: @license_no).buy_order

      raise ExternalError, "购买报告失败" unless result.success?
      if result.success?
        hub = OldDriverRecordHub.create!(
          order_id: result.order_id,
          vin: @vin,
          engine_num: @engine_num,
          license_no: @license_no
        )

        record.update!(old_driver_record_hub_id: hub.id)
      else
        record.update!(state: :generate_fail)
      end
    end

    def buy_report(record:, action: :new, token:)
      vendor_process(record, token, action)
    end

    # 真正去访问接口购买报告
    def vendor_process(record, token, action)
      result = OldDriverService::API.new(vin: @vin,
                                         engine_num: @engine_num,
                                         id_number: @id_numbers,
                                         license_no: @license_no).buy_order
      if result.success? # 得到成功返回
        hub = OldDriverRecordHub.create!(
          order_id: result.order_id,
          vin: @vin,
          engine_num: @engine_num,
          license_no: @license_no
        )

        if action == :refetch
          record.update!(before_update_hub_id: record.old_driver_record_hub_id)
        end
        record.update!(old_driver_record_hub_id: hub.id)
        decrease_token(record, token)
      else
        process_error(record: record,
                      hub: hub,
                      action: action,
                      buy_result: result)
      end
    end

    def init_record(action_type: :new)
      record = OldDriverRecord.new(
        user: @user, company_id: @user.company_id,
        user_name: @user.username,
        shop_id: @user.shop_id, vin: @vin,
        state: :generating, payment_state: :unpaid,
        action_type: action_type, token_price: token_price
      )

      record.save!
      record
    end

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
      @_token_price ||= OldDriverRecord.unit_price
    end

    def process_error(record:, hub:, action:, buy_result:)
      generate_operation_record!(hub, record, action, buy_result.message)

      raise ExternalError, buy_result.message
    end

    def generate_operation_record!(hub, record, action, info = "")
      is_success = false
      message = info

      info = operation_record_info(action, is_success, message)
      type = case action
             when :vin_image
               :vin_image_fail
             else
               is_success ? :insurance_fetch_success : :insurance_fetch_fail
             end

      OperationRecord.create!(operation_record_type: type,
                              user_id: @user.id,
                              shop_id: @user.shop_id,
                              company_id: @user.company_id,
                              messages: { action: action,
                                          car_id: @car_id,
                                          old_driver_record_id: record.try(:id),
                                          title: "保险查询",
                                          car_name: @car.try(:system_name),
                                          vin: @vin,
                                          result: false,
                                          token_price: record.token_price,
                                          info: info,
                                          msg: message })
    end

    def operation_record_info(action, is_success, message)
      case action
      when :new
        is_success ? "【查个车】查询成功。" : "【查个车】查询失败。#{message}"
      when :refetch
        is_success ? "【查个车】更新成功。" : "【查个车】更新失败。#{message}"
      end
    end
  end
end
