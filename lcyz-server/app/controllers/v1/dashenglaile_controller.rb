module V1
  class DashenglaileController < ApplicationController
    skip_before_action :authenticate_user!, except: [:brands]
    before_action :skip_authorization

    def notify
      validate_params

      @hub = DashenglaileRecordHub.find_by(id: params[:order_id].to_i)

      return render text: "failed" unless @hub
      return render text: "already_notified" if @hub.result_status.present?

      notify_reducer
      render text: "success"
    end

    def brands
      param! :query, Hash do |b|
        b.param! :car_id, Integer
      end
      brands = Dashenglaile::Brand.get(company: current_user.company)
      if params[:query] && params[:query][:car_id]
        car = Car.find_by(id: params[:query][:car_id])
        if car
          regex = Regexp.new(car.brand_name)
          chosen = brands.find { |b| regex =~ b["name"] }
        end
      end
      render json: { data: { list: brands, chosen: chosen } }, scope: nil
    end

    private

    def validate_params
      param! :notify_time, String
      param! :notify_type, String
      param! :notify_id, String
      param! :order_id, Integer, required: true
      # param! :last_time_to_shop, Date
      # param! :total_mileage, Integer  # QUERY_FAIL 时是 ""
      param! :vin, String, transform: :upcase
      param! :car_brand_id, Integer
      param! :car_brand, String
      param! :gmt_create, DateTime
      param! :gmt_finish, DateTime
      param! :result_description, String
      param! :result_report, String
      param! :result_images, String, transform: ->(i) { i.split(",") }
      param! :result_status, String, required: true
    end

    def notify_reducer
      @hub.update!(dashenglaile_params)
      case params[:result_status]
      when "QUERY_SUCCESS".freeze
        process_success
      when "QUERY_REJECT".freeze
        process_fail
      when "QUERY_FAIL".freeze
        process_fail
      when "QUERY_NO_RECORD".freeze
        process_fail
      end
    end

    def process_success
      records = DashenglaileRecord.where(dashenglaile_record_hub_id: @hub.id)
      success_operation_record(records)
    end

    def process_fail
      records = DashenglaileRecord.where(dashenglaile_record_hub_id: @hub.id)
      fail_operation_record(@hub.result_description, records)
    end

    def success_operation_record(records)
      type = :maintenance_fetch_success
      records.each do |record|
        result = record.state.generating? ? "【大圣来了】查询成功。" : "【大圣来了】报告已更新。"
        info = "#{record.car.try(:system_name)}<br/> #{record.try(:vin)}<br/> #{result}"
        create_operation(type, record, true, info)
      end
      records.update_all(state: :unchecked, response_at: Time.zone.now)
    end

    def fail_operation_record(message, records)
      records.each do |record|
        price = record.token_price
        refund_token(record, price)
        type = :maintenance_fetch_fail
        result = record.state.generating? ? "【大圣来了】查询失败，" : "【大圣来了】更新失败，"
        info = "#{record.car.try(:system_name)}<br/> #{record.try(:vin)}<br/> #{result}"\
               "#{price}车币已退回。原因：#{message}"
        create_operation(type, record, false, info)
      end
    end

    def refund_token(record, price)
      token = ::Token.find(record.token_id)
      service = TokenService::Income.new(token)
      service.refund(record, price)
    end

    def create_operation(type, record, success, info)
      OperationRecord.create(operation_record_type: type,
                             user_id: record.last_fetch_by,
                             targetable: record,
                             shop_id: record.shop_id,
                             company_id: record.company_id,
                             messages: { action: :notify,
                                         title: "维保查询",
                                         car_id: record.car_id,
                                         platform_name: record.platform_name,
                                         dashenglaile_record_id: record.id,
                                         car_name: record.car.try(:system_name),
                                         vin: record.try(:vin),
                                         result: success,
                                         info: info })
    end

    def dashenglaile_params
      params.permit(:notify_time, :notify_type, :notify_id, :last_time_to_shop,
                    :total_mileage, :number_of_accidents,
                    :car_brand_id, :car_brand,
                    :result_description, :result_status,
                    :gmt_create, :gmt_finish, :order_id,
                    :result_content, :result_report,
                    result_images: [])
    end

    def parse_json(json)
      JSON.parse(json)
    rescue JSON::ParserError => _e
      return ""
    end
  end
end
