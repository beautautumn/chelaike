class RongMessageService
  MESSAGE_STATISTICS = :statistics
  MESSAGE_STOCK = :stock
  MESSAGE_CUSTOMER = :customer
  MESSAGE_SYSTEM = :system
  MESSAGE_LOAN = :loan

  TYPE_GROUP_MAP = {
    MESSAGE_STATISTICS => [:statistics],
    MESSAGE_SYSTEM => [:solo_messagble, :alliance_messagable],
    MESSAGE_CUSTOMER => [:intention_messagable],
    MESSAGE_STOCK => [:messagable],
    MESSAGE_LOAN => [:loan_messagable]
  }.freeze

  attr_accessor :operation_record

  def initialize(operation_record, user_ids)
    @operation_record = operation_record
    @from_user_id = system_messager_id
    @to_user_ids = rongcloud_user_ids(user_ids)
  end

  def publish
    rong_push = Util::RongPush.new(
      @from_user_id,
      @to_user_ids,
      operation_record_content
    )

    if vin_image_request_type?
      rong_push.private_send
    else
      rong_push.send
    end
  end

  private

  def rongcloud_user_ids(user_ids)
    rc_prefix = ENV["RC_PREFIX"] || ""
    rc_prefix = "#{rc_prefix}_" if rc_prefix.present?

    user_ids.map do |id|
      "#{rc_prefix}#{id}"
    end
  end

  def vin_image_request_type?
    @operation_record.operation_record_type == "vin_image_request"
  end

  def operation_record_content
    send("#{@operation_record.message_type}_content")
  end

  def customer_content
    {
      content: @operation_record.intention_message_text,
      extra: {
        operation_record_id: @operation_record.id,
        message_type: @operation_record.operation_record_type,
        intention_id: @operation_record.messages["intention_id"],
        notification_type: :customer
      }
    }
  end

  def stock_content
    {
      content: @operation_record.message_text(notification_alert: true),
      extra: {
        operation_record_id: @operation_record.id,
        message_type: @operation_record.operation_record_type,
        car_id: @operation_record.messages["car_id"],
        notification_type: :stock
      }
    }
  end

  def statistics_content
    content_text = case @operation_record.operation_record_type.to_s
                   when "daily_report"
                     "今日统计，点击查看详情"
                   when "alliance_cars_created_statistic"
                     @operation_record.message_text(notification_alert: true)
                   end

    {
      content: content_text,
      extra: {
        operation_record_id: @operation_record.id,
        message_type: @operation_record.operation_record_type,
        notification_type: :statistics
      }
    }
  end

  def system_content
    if vin_image_request_type?
      {
        content: "有新的vin码要识别啦,快去干活吧。->_-> 猛戳地址：#{page_url}",
        extra: {
          operation_record_id: @operation_record.id,
          message_type: @operation_record.operation_record_type,
          message_id: @operation_record.id,
          notification_type: :system
        }
      }
    else
      content = begin
                  @operation_record.alliance_message_text
                rescue I18n::MissingInterpolationArgument => _e
                  @operation_record.message_text
                end
      {
        content: content,
        extra: {
          operation_record_id: @operation_record.id,
          message_type: @operation_record.operation_record_type,
          message_id: @operation_record.id,
          alliance_id: @operation_record.messages["alliance_id"],
          company_id: @operation_record.messages["company_id"],
          company_name: @operation_record.messages["company_name"],
          report_id: report_info[:id],
          report_type: report_info[:type],
          notification_type: :system
        }
      }
    end
  end

  def report_info
    case @operation_record.operation_record_type
    when "insurance_fetch_success"
      {
        id: @operation_record.targetable_id,
        type: :old_driver_record
      }
    when "maintenance_fetch_success"
      maintenance_report_info
    else
      {
        id: nil,
        type: nil
      }
    end
  end

  def maintenance_report_info
    maintenance_record = @operation_record.targetable
    case @operation_record.targetable_type
    when "ChaDoctorRecord"
      {
        id: maintenance_record.id,
        type: :cha_doctor_record
      }
    when "AntQueenRecord"
      {
        id: maintenance_record.id,
        type: :ant_queen_record
      }
    when "MaintenanceRecord"
      {
        id: maintenance_record.id,
        type: :maintenance_record
      }
    when "DashenglaileRecord"
      {
        id: maintenance_record.id,
        type: :dashenglaile_record
      }
    end
  end

  def loan_content
    {
      content: @operation_record.loan_message_text,
      extra: {
        operation_record_id: @operation_record.id,
        message_type: @operation_record.operation_record_type,
        object_type: @operation_record.targetable_type,
        object_id: @operation_record.targetable_id,
        notification_type: :loan
      }
    }
  end

  # 给出后台vin码识别地址
  def page_url
    platform = @operation_record.messages["platform"]
    platform_str = {
      "cha_doctor" => "drCha",
      "dasheng" => "monkeyKing"
    }.fetch(platform)

    record_id = @operation_record.messages["record_id"]

    url_id = Base64.urlsafe_encode64("#{platform_str}#{record_id}")

    url = if Rails.env == "staging"
            "http://218.244.145.150:9292/dashboard/vin_images/#{url_id}"
          else
            "http://fighting.chelaike.com/vin_images/#{url_id}"
          end

    CGI.escape(url.strip)
  end

  def system_messager_id
    if vin_image_request_type?
      User.find_by(username: "小车车").id
    else
      SystemMessageUser.get_messager(@operation_record.message_type).rongcloud_id
    end
  end
end
