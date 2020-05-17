class OperationRecord < ActiveRecord::Base
  class MessageTextService
    attr_reader :messages, :operation_record_type, :notification_alert

    def initialize(operation_record, notification_alert: false)
      @messages = operation_record.messages
      @operation_record_type = operation_record.operation_record_type

      @notification_alert = notification_alert
    end

    def execute
      return send(operation_record_type) if respond_to?(operation_record_type)

      I18n.t(
        default_path,
        user_name: messages["user_name"],
        car_name: messages["name"],
        type: operation_record_type
      )
    end

    def state_changed
      I18n.t(
        "operation_record.messages.state_changed",
        user_name: messages["user_name"],
        car_name: messages["name"],
        state_text: I18n.t("enumerize.car.state.#{messages["current_state"]}"),
        type: operation_record_type
      )
    end

    def stock_out
      I18n.t(
        "operation_record.messages.stock_out.#{messages["stock_out_type"]}",
        user_name: messages["user_name"],
        car_name: messages["name"],
        seller_name: messages["seller_name"],
        alliance_name: messages["alliance_name"],
        new_company_name: messages["new_company_name"],
        type: operation_record_type
      )
    end

    def alliance_cars_created_statistic
      paths = [default_path]
      paths << "notification_alert" if notification_alert
      paths << "normal"

      I18n.t(
        paths.join("."),
        alliance_name: messages["alliance_name"],
        cars_count: messages["cars_count"],
        intentions_count: messages["intentions_count"]
      )
    end

    def car_created
      matched_intentions_count = messages["matched_intentions_count"]

      paths = [default_path]
      paths << "notification_alert" if notification_alert
      paths << (matched_intentions_count.to_i > 0 ? "intentions" : "normal")

      I18n.t(
        paths.join("."),
        user_name: messages["user_name"],
        car_name: messages["name"],
        matched_intentions_count: matched_intentions_count,
        type: operation_record_type
      )
    end

    def alliance_stock_in
      I18n.t(
        "operation_record.messages.alliance_stock_in",
        car_name: messages["name"],
        type: operation_record_type
      )
    end

    def alliance_stock_back
      I18n.t(
        "operation_record.messages.alliance_stock_back",
        car_name: messages["name"],
        type: operation_record_type
      )
    end

    def token_recharge
      I18n.t(
        default_path,
        token: messages["token"],
        type: operation_record_type
      )
    end

    def maintenance_fetch_fail
      I18n.t(
        default_path,
        vin: messages["vin"],
        result: "查询失败，请稍后再试。",
        type: operation_record_type,
        car_name: messages["car_name"],
        platform_name: messages["platform_name"],
        info: messages["info"]
      )
    end

    def maintenance_fetch_success
      I18n.t(
        default_path,
        vin: messages["vin"],
        result: "查询成功。",
        type: operation_record_type,
        car_name: messages["car_name"],
        platform_name: messages["platform_name"],
        info: messages["info"]
      )
    end

    def insurance_fetch_success
      I18n.t(
        default_path,
        vin: messages["vin"],
        result: "查询成功。",
        type: operation_record_type,
        car_name: messages["car_name"],
        info: messages["info"]
      )
    end

    def insurance_update_success
      I18n.t(
        default_path,
        vin: messages["vin"],
        result: "更新成功。",
        type: operation_record_type,
        car_name: messages["car_name"],
        info: messages["info"]
      )
    end

    def insurance_fetch_fail
      I18n.t(
        default_path,
        vin: messages["vin"],
        result: "查询失败。",
        type: operation_record_type,
        car_name: messages["car_name"],
        info: messages["info"]
      )
    end

    def remind_intention_due
      I18n.t(
        default_path,
        customer_name: messages["customer_name"]
      )
    end

    def stock_warning
      I18n.t(
        default_path,
        user_name: messages["user_name"],
        car_name: messages["car_name"],
        type: operation_record_type,
        stock_status: messages["stock_status"]
      )
    end

    def remind_restock
      I18n.t(
        default_path,
        user_name: messages["user_name"],
        car_name: messages["car_name"],
        state: messages["state"],
        color: messages["color"],
        stock_number: messages["stock_number"]
      )
    end

    def vin_image_fail
      I18n.t(
        default_path,
        user_name: messages["user_name"],
        car_name: messages["car_name"],
        info: messages["info"],
        msg: messages["msg"],
        platform_name: messages["platform_name"],
        token_price: messages["token_price"],
        type: operation_record_type
      )
    end

    def vin_image_request
      I18n.t(
        default_path,
        company_name: messages["company_name"],
        car_name: messages["car_name"],
        type: operation_record_type
      )
    end

    private

    def default_path
      "operation_record.messages.#{operation_record_type}"
    end
  end
end
