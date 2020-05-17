module V1
  class AntQueenController < ApplicationController
    skip_before_action :authenticate_user!, except: [:brands]
    before_action :skip_authorization

    def notify
      validate_params

      @hub = AntQueenRecordHub.find_by(id: params[:order_id].to_i)

      return render text: "failed" unless @hub
      return render text: "already_notified" if @hub.result_status.present?

      notify_reducer
      render text: "success"
    end

    def brands
      param! :query, Hash do |b|
        b.param! :car_id, Integer
      end
      brands = AntQueen::Brand.get(company: current_user.company)
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
      param! :total_mileage, Integer
      param! :vin, String, transform: :upcase
      param! :car_brand_id, Integer
      param! :car_brand, String
      param! :gmt_create, DateTime
      param! :gmt_finish, DateTime
      param! :result_description, String
      param! :result_images, String, transform: ->(i) { i.split(",") }
      param! :result_status, String, required: true
    end

    def notify_reducer
      @hub.update!(ant_queen_params)
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
      records = AntQueenRecord.where(ant_queen_record_hub_id: @hub.id)
      success_operation_record(records)
    end

    def process_fail
      records = AntQueenRecord.where(ant_queen_record_hub_id: @hub.id)
      fail_operation_record(@hub.result_description, records)
    end

    def success_operation_record(records)
      type = :maintenance_fetch_success
      records.each do |record|
        info = record.state.generating? ? "【蚂蚁女王】查询成功。" : "【蚂蚁女王】报告已更新。"
        create_operation(type, record, true, info)
      end
      records.update_all(state: :unchecked, vin: params[:vin])
    end

    def fail_operation_record(message, records)
      records.each do |record|
        price = record.token_price
        refund_token(record, price)
        type = :maintenance_fetch_fail
        info = case record.state
               when "generating"
                 "【蚂蚁女王】查询失败，#{message}，#{price}车币已退回。"
               else
                 "【蚂蚁女王】更新失败，#{message}，#{price}车币已退回。"
               end
        create_operation(type, record, false, info)
      end
    end

    def refund_token(record, price)
      token = Token.find(record.token_id)
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
                                         ant_queen_record_id: record.id,
                                         car_name: record.car.try(:system_name),
                                         vin: params[:vin],
                                         result: success,
                                         info: info })
    end

    def ant_queen_params
      params.permit(:notify_time, :notify_type, :notify_id, :vin,
                    :number_of_accidents, :last_time_to_shop, :result_description,
                    :total_mileage, :car_brand_id, :car_brand,
                    :gmt_create, :gmt_finish, :result_status,
                    result_images: []).tap do |whitelisted|
        %i(text_img_json text_contents_json query_text car_status car_info).each do |key|
          whitelisted[key] = parse_json(params[key]) if params[key].present?
        end
      end
    end

    def parse_json(json)
      JSON.parse(json)
    rescue JSON::ParserError => _e
      return ""
    end
  end
end
