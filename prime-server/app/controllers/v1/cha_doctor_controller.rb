module V1
  class ChaDoctorController < ApplicationController
    skip_before_action :authenticate_user!
    before_action :skip_authorization

    def notify
      param! :result, String
      param! :orderid, String
      param! :message, String

      @hub = ChaDoctorRecordHub.find_by(
        order_id: params[:orderid],
        notify_status: nil
      )

      if @hub
        render text: "success"
        handle_notify
      else
        render text: "failed"
      end
    end

    private

    def handle_notify
      state = params[:result] == "1" ? :success : :failed

      process_hub_records(state)
      process_detail_logic(state)
      notify_records(state)
    end

    def process_detail_logic(state)
      if state == :success
        fetch_report_detail
      else
        refund_token
      end
    end

    def process_hub_records(state)
      @hub.transaction do
        @hub.update!(
          notify_at: Time.zone.now,
          notify_status: params[:result],
          notify_message: params[:message],
          notify_state: state
        )

        @hub.latest_records.each do |record|
          record.process_result(@hub)
        end
      end
    end

    def fetch_report_detail
      # 如果在拉取报告时出错，应该如何处理？
      ChaDoctorService::GetReport.new(@hub).execute
    end

    # 通知报告相关的查询记录者
    def notify_records(state)
      case state
      when :success
        process_success
      else
        process_fail
      end
    end

    def process_success
      records = @hub.latest_records
      success_operation_record(records)
    end

    def process_fail
      records = @hub.latest_records
      fail_operation_record(records)
    end

    def success_operation_record(records)
      type = :maintenance_fetch_success
      records.each do |record|
        info = record.action_type.new? ? "【查博士】查询成功。" : "【查博士】报告已更新。"
        create_operation(type, record, true, info)
      end
    end

    def fail_operation_record(records)
      type = :maintenance_fetch_fail
      records.each do |record|
        price = record.token_price
        message = @hub.notify_message
        info = case record.action_type
               when "new"
                 "【查博士】查询失败，#{message}，#{price}车币已退回。"
               else
                 "【查博士】更新失败，#{message}，#{price}车币已退回。"
               end

        create_operation(type, record, false, info)
      end
    end

    def create_operation(type, record, success, info)
      OperationRecord.create(operation_record_type: type,
                             user_id: record.user_id,
                             targetable: record,
                             shop_id: record.shop_id,
                             company_id: record.company_id,
                             messages: { action: :notify,
                                         title: "维保查询",
                                         car_id: record.car_id,
                                         cha_doctor_record_id: record.id,
                                         car_name: record.car.try(:system_name),
                                         vin: record.vin,
                                         result: success,
                                         info: info })
    end

    def refund_token
      records = @hub.latest_records
      price = ChaDoctorRecord.unit_price

      records.each do |record|
        next unless record.payment_state.paid?
        token = Token.find(record.token_id)
        service = TokenService::Income.new(token)
        service.refund(record, price)
        record.update!(payment_state: :refunded)
      end
    end
  end
end
