module V1
  class CheJianDingController < ApplicationController
    NotifyOrder = Struct.new(:order_id, :vin, :order_status, :time, :sign, :data_json) do
      def finished?
        order_status == 2
      end

      def data_json_hash
        MultiJson.load(data_json) if data_json.present?
      end

      def message_text
        {
          "2" => "订单完成",
          "3" => "VIN审核未通过",
          "5" => "无维修保养记录",
          "6" => "暂不支持品牌",
          "8" => "品牌系统维护中",
          "10" => "VIN错误",
          "11" => "车牌有误",
          "13" => "发动机有误"
        }.fetch(order_status.to_s, "")
      end

      def to_hub_params
        to_h.slice(:vin).merge(
          report_at: Time.zone.now,
          notify_status: order_status,
          notify_message: message_text
        )
      end
    end

    skip_before_action :authenticate_user!
    before_action :skip_authorization, :params_verify

    serialization_scope :anonymous

    def notify
      hub = find_hub

      if hub
        # 如果在等待返回结果中，又有其他人发起查询请求，最终回调会给这两个人发送消息
        records = hub.maintenance_records

        hub.transaction do
          hub.update!(@notify_order.to_hub_params)
          hub.maintenance_records.update_all(vin: @notify_order.vin)
        end

        CheJianDing.parse_and_persisted_json(
          hub, @notify_order.data_json_hash) if @notify_order.finished?

        generate_operation_record(
          @notify_order.finished?,
          @notify_order.message_text,
          records
        )

        render json: { info: { status: 1, message: "成功" } }, scope: nil
      else
        render json: { info: { status: 0, message: "Can not find orderId" } }, scope: nil
      end
    end

    private

    def find_hub
      MaintenanceRecordHub.where(
        order_id: @notify_order.order_id,
        notify_status: nil
      ).first
    end

    # 处理退款
    def refund_token(record, price)
      token = Token.find(record.token_id)
      service = TokenService::Income.new(token)
      service.refund(record, price)
    end

    def params_verify
      param! :orderId, String, required: true
      param! :vin, String, required: true
      param! :orderStatus, Integer, required: true
      param! :time, DateTime, required: true
      param! :sign, String, required: true
      param! :dataJson, String, required: false

      if verify?
        @notify_order = NotifyOrder.new(
          params[:orderId],
          params[:vin],
          params[:orderStatus],
          params[:time],
          params[:sign],
          params[:dataJson]
        )
      else
        render(json: { info: { status: 0, message: "Invalid Data" } }, scope: nil)
      end
    end

    def verify?
      time = Util::Formatter.to_string_time(params[:time])
      RedisClient.current.set("chejainding_last_notify_parmas_for_debug", params)
      data = "#{params[:orderId]}#{params[:vin]}" \
             "#{params[:orderStatus]}#{time}#{CheJianDing.pwd}"
      CheJianDing.notify_public_key.verify("SHA1", Base64.strict_decode64(params[:sign]), data)
    end

    def generate_operation_record(success, message, records)
      records.each do |record|
        price = record.token_price
        if success
          type = :maintenance_fetch_success
          info = case record.state
                 when "generating" then "【车鉴定】查询成功。"
                 else "【车鉴定】报告已更新。"
                 end
        else
          refund_token(record, price)
          type = :maintenance_fetch_fail
          info = case record.state
                 when "generating"
                   "【车鉴定】查询失败，#{message}，#{price}车币已退回。"
                 else
                   "【车鉴定】更新失败，#{message}，#{price}车币已退回。"
                 end
        end
        create_operation(type, record, success, info)
      end
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
                                         maintenance_record_id: record.id,
                                         car_name: record.car.try(:system_name),
                                         vin: params[:vin],
                                         result: success,
                                         info: info })
    end
  end
end
