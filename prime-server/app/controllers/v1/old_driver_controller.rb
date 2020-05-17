# 老司机回调接口
module V1
  class OldDriverController < ApplicationController
    skip_before_action :authenticate_user!
    before_action :skip_authorization

    def notify
      param! :OrderID, String
      param! :Status, Integer
      param! :Make, String
      param! :Msg, String
      param! :Insurance, Array
      param! :Claims, Array
      param! :MeterError, :boolean
      param! :SmokeLevel, String
      param! :Year, String
      param! :Nature, String

      @hub = OldDriverRecordHub.where(order_id: params["OrderID"]).last

      if @hub.notify_at.blank?
        handle_notify
      end

      render text: "success"
    end

    private

    def handle_notify
      # 只有成功才会调
      update_hub!
      notify_records
    end

    def update_hub!
      @hub.update!(
        notify_at: Time.zone.now,
        make: params["Make"],
        meter_error: params["MeterError"],
        smoke_level: params["SmokeLevel"],
        year: params["Year"],
        nature: params["Nature"],
        insurance: params["Insurance"],
        claims: params["Claims"]
      )

      @hub.old_driver_records.map do |record|
        record.update!(state: :unchecked)
      end
    end

    def notify_records
      records = @hub.old_driver_records
      success_operation_record(records)
    end

    def success_operation_record(records)
      type = :insurance_fetch_success
      records.each do |record|
        info = record.action_type.new? ? "【查个车】查询成功。" : "【查个车】报告已更新。"
        type = record.action_type.new? ? :insurance_fetch_success : :insurance_update_success
        create_operation(type, record, true, info)
      end
    end

    def create_operation(type, record, success, info)
      OperationRecord.create(operation_record_type: type,
                             user_id: record.user_id,
                             targetable: record,
                             shop_id: record.shop_id,
                             company_id: record.company_id,
                             messages: { action: :notify,
                                         title: "保险查询",
                                         car_id: record.car_id,
                                         old_driver_record_id: record.id,
                                         car_name: record.car.try(:system_name),
                                         vin: record.vin,
                                         result: success,
                                         info: info })
    end
  end
end
