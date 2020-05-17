class DailyReportWorker
  include Sidekiq::Worker

  sidekiq_options retry: 1, queue: :daily_report

  def perform(company_id)
    @company = Company.find(company_id)

    operation_record = create_operation_record

    user_ids = push_user_ids(operation_record)

    # target_tag = Util::Jpush.users_tag(user_ids)

    # send_jpush(operation_record, target_tag)
    send_rong_push(operation_record, user_ids)
  end

  def create_operation_record
    @company.operation_records.create!(
      user: @company.owner,
      company_id: @company.id,
      operation_record_type: :daily_report,
      messages: {
        cars_created_today: cars_created_today,
        cars_reserved_today: cars_reserved_today,
        cars_sold_today: cars_sold_today,
        cars_created_current_month: cars_created_current_month,
        cars_sold_current_month: cars_sold_current_month,
        cars_stock_status_normal: cars_stock_status_normal,
        cars_stock_status_yellow: cars_stock_status_yellow,
        cars_stock_status_red: cars_stock_status_red
      }
    )
  end

  def cars_created_today
    Car.where(company_id: @company.id)
       .where(
         "created_at >= ? AND created_at <= ?",
         Time.zone.now.beginning_of_day, Time.zone.now.end_of_day
       ).pluck(:id)
  end

  def cars_created_current_month
    Car.where(company_id: @company.id)
       .where(
         "created_at >= ? AND created_at <= ?",
         Time.zone.now.beginning_of_month, Time.zone.now.end_of_month
       ).pluck(:id)
  end

  def cars_reserved_today
    Car.where(company_id: @company.id)
       .where(
         "reserved_at >= ? AND reserved_at <= ?",
         Time.zone.now.beginning_of_day, Time.zone.now.end_of_day
       ).pluck(:id)
  end

  def cars_sold_today
    Car.where(company_id: @company.id)
       .joins(:sale_record)
       .where("stock_out_inventories.completed_at = ?", Time.zone.now.to_date)
       .pluck(:id)
  end

  def cars_sold_current_month
    Car.where(company_id: @company.id)
       .joins(:sale_record)
       .where("stock_out_inventories.completed_at >= ?", Time.zone.today.beginning_of_month)
       .where("stock_out_inventories.completed_at <= ?", Time.zone.today.end_of_month)
       .pluck(:id)
  end

  def cars_stock_status_normal
    Car.where(company_id: @company.id).state_in_stock_scope
       .where("stock_age_days < yellow_stock_warning_days")
       .pluck(:id)
  end

  def cars_stock_status_yellow
    Car.where(company_id: @company.id).state_in_stock_scope
       .where("stock_age_days < red_stock_warning_days
               AND stock_age_days >= yellow_stock_warning_days")
       .pluck(:id)
  end

  def cars_stock_status_red
    Car.where(company_id: @company.id).state_in_stock_scope
       .where("stock_age_days >= red_stock_warning_days")
       .pluck(:id)
  end

  def send_jpush(operation_record, target_tag)
    params = {
      alert: "今日统计，点击查看详情",
      badge: "+1",
      sound: "default",
      extras: {
        operation_record_id: operation_record.id,
        message_type: operation_record.operation_record_type
      }
    }

    payload = JPush::PushPayload.new(
      platform: JPush::Platform.all,
      audience: JPush::Audience.build(
        tag: target_tag
      ),
      notification: JPush::Notification.build(
        alert: params[:alert],
        ios: JPush::IOSNotification.build(params),
        android: JPush::AndroidNotification.build(params)
      )
    )

    Util::Jpush.new.send(payload)
  end

  def send_rong_push(operation_record, user_ids)
    RongMessageService.new(operation_record, user_ids).publish
  end

  def push_user_ids(operation_record)
    user_ids = User.where(company_id: operation_record.company_id)
                   .authorities_include("库存统计查看")
                   .pluck(:id)

    Message.create_messages(operation_record, user_ids)

    user_ids
  end
end
