module Dashenglaile
  class FetchService
    ERRORS = [
      Dashenglaile::Error::Buy,
      Dashenglaile::Error::Request,
      Dashenglaile::Error::Token,
      Dashenglaile::Error::Vin,
      Dashenglaile::Error::Vendor
    ].freeze

    attr_accessor :hub, :record

    # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    def initialize(vin, user, token, **options)
      @vin = vin
      @is_image = options[:is_image]
      @vin.upcase! if !@is_image && @vin.present?
      @record = options[:record]

      @current_user = if @record.present? && @record.last_fetch_by.present?
                        User.find(@record.last_fetch_by)
                      else
                        user
                      end

      @company = @current_user.company if @current_user.present?

      @brand_id = options[:brand_id]
      @action = options[:action].present? ? options[:action] : :new
      @token = token

      if options[:car_id].present?
        @car_id = options[:car_id]
        @car = Car.find_by(id: options[:car_id])
      elsif @current_user.present?
        @car = Car.find_by(company_id: @current_user.company_id, vin: vin)
        @car_id = @car.id if @car
      end
      @engine_num = options[:engine_num]

      set_brand_info
    end
    # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

    def execute
      check_token! do
        case @action
        when :new
          fetch
        when :refetch
          vendor_process
          update_current_record
          @record.set_timeout_worker
        end
      end
    end

    def fire(record, failed = false, info = nil)
      @record = record
      @current_user = User.find(@record.last_fetch_by)
      @company = @current_user.company
      @token = ::Token.find(@record.token_id) # fire 时可以不传 token

      if failed # 识别失败, 退款, 提示用户
        @action = :vin_image
        refund_token
        @record.update!(state: :vin_image_fail)
        generate_operation_record(false, info)
      else # 识别成功, 回写 vin
        @hub = @record.dashenglaile_record_hub
        @hub.update!(vin: @vin)
        @record.update!(vin: @vin, request_at: Time.zone.now) # 记录发起时间

        @car = Car.find_by(company_id: @current_user.company_id, vin: @vin)
        @car_id = @car.id if @car
        # 发起查询
        Dashenglaile::Record.query(
          brand_id: @hub.car_brand_id,
          vin: @vin,
          _is_vin: true,
          order_id: @hub.id,
          engine_num: @hub.engine_num
        )
        @record.update!(state: :generating)
        @hub.update!(order_id: @hub.id.to_i, request_success: true)
      end
    end

    private

    def check_token!
      raise Dashenglaile::Error::Token, "车币不足" unless @token
      raise Dashenglaile::Error::Token if @token.balance.to_d < @token_price
      yield
    end

    def set_brand_info
      dasheng_brand = Dashenglaile::Brand.brand_info(@vin) || {}
      if dasheng_brand["is_pause"] == "1"
        raise Dashenglaile::Error::Vendor, "该品牌系统维护, 暂不支持查询"
      end
      @brand_id ||= dasheng_brand.try(:[], "brand_id")

      @token_price = DashenglaileRecord.unit_price(
        car_brand_id: @brand_id,
        company: @company
      )

      @brand_name = dasheng_brand.try(:[], "brand_name")
    end

    def fetch
      hub = DashenglaileRecordHub.available_hub(@vin)
      if !@is_image
        if hub
          generate_new_record(:unchecked, hub)
          generate_operation_record(true) if hub.notify_success?
        else
          vendor_process
          generate_new_record(:generating, @new_hub)
        end
      else # 提交图片
        vendor_process
        generate_new_record(:submitted, @new_hub) # 状态标记为已提交
        generate_reminder_record
      end
      decrease_token
    end

    def vendor_process
      @new_hub = DashenglaileRecordHub.create!(
        car_brand_id: @brand_id,
        car_brand: @brand_name
      )
      unless @is_image
        Dashenglaile::Record.query(
          brand_id: @brand_id,
          vin: @vin,
          order_id: @new_hub.id,
          engine_num: @engine_num
        )
        @new_hub.update!(order_id: @new_hub.id.to_i, request_success: true)
      end
      # 如果提交了图片, 等待后台处理
    end

    def update_current_record
      old_hub = @record.dashenglaile_record_hub
      last_dashenglaile_record_hub_id = old_hub.notify_success? ? old_hub.id : nil
      @record.update!(dashenglaile_record_hub_id: @new_hub.id,
                      user_name: @current_user.name,
                      token_price: @token_price,
                      pre_token_price: @record.token_price,
                      last_fetch_by: @current_user.id,
                      last_fetch_at: Time.zone.now,
                      last_dashenglaile_record_hub_id: last_dashenglaile_record_hub_id,
                      state: :updating)
      decrease_token
    end

    def decrease_token
      service = TokenService::Payout.new(@token)
      service.pay(action_type: :maintenance_query,
                  subject: @record,
                  user: @current_user,
                  amount: @record.token_price)
    end

    def refund_token
      token = ::Token.find(@record.token_id)
      service = TokenService::Income.new(token)
      service.refund(@record, @record.token_price)
    end

    def generate_new_record(state, hub)
      attr = {
        car_id: @car_id,
        dashenglaile_record_hub_id: hub.id,
        company_id: @current_user.company_id,
        shop_id: @current_user.shop_id,
        user_name: @current_user.name,
        last_fetch_by: @current_user.id,
        last_fetch_at: Time.zone.now,
        token_price: @token_price,
        state: state,
        car_brand_id: @brand_id,
        engine_num: @engine_num,
        request_at: Time.zone.now # 请求发起时间
      }
      if @is_image
        attr[:vin_image] = @vin
      else
        attr[:vin] = @vin
      end
      @record = DashenglaileRecord.create!(attr)
    end

    # rubocop:disable Metrics/CyclomaticComplexity
    def generate_operation_record(success, message = "")
      type = success ? :maintenance_fetch_success : :maintenance_fetch_fail
      case @action
      when :new
        info = success ? "【大圣来了】查询成功。" : "【大圣来了】查询失败，#{message}"
      when :refetch
        info = success ? "【大圣来了】查询成功。" : "【大圣来了】更新失败，#{message}"
      when :vin_image # 目前只记录 VIN 识别失败
        type = :vin_image_fail
        msg = message.presence || "VIN码不能识别, 请重新上传"
        info = "#{@car.try(:system_name)}<br/>【大圣来了】"\
                "#{msg}，#{@token_price}车币已退回。"
      end

      OperationRecord.create!(operation_record_type: type,
                              user_id: @current_user.id,
                              shop_id: @current_user.shop_id,
                              company_id: @current_user.company_id,
                              messages: { action: @action,
                                          car_id: @car_id,
                                          dashenglaile_record_hub_id: @record.try(:id),
                                          title: "维保查询",
                                          car_name: @car.try(:system_name),
                                          platform_name: @record.platform_name,
                                          token_price: @token_price,
                                          vin: @vin,
                                          result: false,
                                          info: info,
                                          msg: message })
    end
    # rubocop:enable Metrics/CyclomaticComplexity

    def generate_reminder_record
      xiaocheche = User.find_by(name: "小车车")

      OperationRecord.create!(operation_record_type: :vin_image_request,
                              user_id: xiaocheche.id,
                              shop_id: xiaocheche.shop_id,
                              company_id: xiaocheche.company_id,
                              messages: { car_id: @car_id,
                                          dashenglaile_record_hub_id: @record.try(:id),
                                          platform: :dasheng,
                                          record_id: @record_id.try(:id),
                                          title: "VIN码识别",
                                          car_name: @car.try(:system_name),
                                          company_name: @car.try(:company).try(:name) })
    end
  end
end
