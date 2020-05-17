module AntQueen
  class FetchService
    ERRORS = [
      AntQueen::Error::Buy,
      AntQueen::Error::Token
    ].freeze

    def initialize(vin, current_user, token, brand_id, options = { action: :new })
      @vin = vin
      @is_image = options[:is_image]
      @is_text = options[:is_text]
      @vin.upcase! unless @is_image

      @current_user = current_user
      @company = @current_user.company
      @token = token
      @brand_id = brand_id
      @action = options[:action]

      if options[:car_id].present?
        @car_id = options[:car_id]
        @car = Car.find_by(id: options[:car_id])
      else
        @car = Car.find_by(company_id: current_user.company_id, vin: vin)
        @car_id = @car.id if @car
      end
      @record = options[:record]
      @engine_num = options[:engine_num]

      set_brand_info
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
    end

    private

    def set_brand_info
      ant_brand = AntQueen::Brand.get(company: @company)
                                 .find { |b| b["id"].to_i == @brand_id }
      @token_price = AntQueenRecord.unit_price(
        brand: ant_brand,
        company: @company
      )
      @brand_name = ant_brand.try(:[], "name")
    end

    def fetch
      time = Time.zone.now - AntQueenRecordHub::EXPERATION
      hub_lambda = lambda do
        AntQueenRecordHub.notify_success
                         .where(vin: @vin, car_brand_id: @brand_id)
                         .where("created_at >= ?", time)
                         .where(request_success: true)
                         .order(created_at: :desc).first
      end
      # rubocop:disable Lint/AssignmentInCondition
      if !@is_image && hub = hub_lambda.call
        generate_new_record(:unchecked, hub)
        decrease_token
        generate_operation_record(true) if hub.notify_success?
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

    def vendor_process
      is_vin = @is_image ? nil : 2
      @new_hub = AntQueenRecordHub.create!(
        car_brand_id: @brand_id,
        car_brand: @brand_name,
        request_sent_at: Time.zone.now
      )

      req = AntQueen::Record.query(
        brand_id: @brand_id,
        vin: @vin,
        is_vin: is_vin,
        order_id: @new_hub.id,
        engine_num: @engine_num,
        is_text: @is_text
      )
      raise AntQueen::Error::Buy unless req.present? && req["code"].to_i == 200
      @new_hub.update!(query_id: req["query_id"].to_i, request_success: true)
    end

    def update_current_record
      old_hub = @record.ant_queen_record_hub
      last_ant_queen_record_hub_id = old_hub.notify_success? ? old_hub.id : nil
      @record.update!(ant_queen_record_hub_id: @new_hub.id,
                      user_name: @current_user.name,
                      token_price: @token_price,
                      pre_token_price: @record.token_price,
                      last_fetch_by: @current_user.id,
                      last_fetch_at: Time.zone.now,
                      last_ant_queen_record_hub_id: last_ant_queen_record_hub_id,
                      state: :updating)
      @token.decrement!(:balance, @record.token_price)
    end

    def generate_new_record(state, hub)
      attr = {
        car_id: @car_id,
        ant_queen_record_hub_id: hub.id,
        company_id: @current_user.company_id,
        shop_id: @current_user.shop_id,
        user_name: @current_user.name,
        last_fetch_by: @current_user.id,
        last_fetch_at: Time.zone.now,
        token_price: @token_price,
        state: state,
        car_brand_id: @brand_id,
        engine_num: @engine_num
      }
      if @is_image
        attr[:vin_image] = @vin
      else
        attr[:vin] = @vin
      end
      @record = AntQueenRecord.create!(attr)
    end

    def generate_operation_record(success, message = "")
      case @action
      when :new
        info = success ? "【蚂蚁女王】查询成功。" : "【蚂蚁女王】查询失败，#{message}"
      when :refetch
        info = success ? "【蚂蚁女王】查询成功。" : "【蚂蚁女王】更新失败，#{message}"
      end
      type = success ? :maintenance_fetch_success : :maintenance_fetch_fail
      OperationRecord.create!(operation_record_type: type,
                              user_id: @current_user.id,
                              shop_id: @current_user.shop_id,
                              company_id: @current_user.company_id,
                              messages: { action: @action,
                                          car_id: @car_id,
                                          ant_queen_record_id: @record.try(:id),
                                          title: "维保查询",
                                          car_name: @car.try(:system_name),
                                          vin: @vin,
                                          result: false,
                                          info: info })
    end
  end
end
