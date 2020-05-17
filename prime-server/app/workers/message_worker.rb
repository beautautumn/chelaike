class MessageWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(operation_record_id, solo = false)
    operation_record = OperationRecord.find(operation_record_id)

    user_ids, = push_tag(operation_record, solo)

    send_rong_push(operation_record, user_ids)

    # send_jpush(operation_record, target_tag)
  end

  def send_rong_push(operation_record, user_ids)
    RongMessageService.new(operation_record, user_ids).publish
  end

  def send_jpush(operation_record, target_tag)
    params = {
      alert: operation_record.message_text(notification_alert: true),
      badge: "+1",
      sound: "default",
      extras: {
        operation_record_id: operation_record.id,
        message_type: operation_record.operation_record_type,
        car_id: operation_record.messages["car_id"]
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

  private

  def push_tag(operation_record, solo)
    authority = operation_record.message_notify_authority
    if solo
      Message.create_messages(operation_record, [operation_record.user_id])
      [[operation_record.user_id], ["user_#{operation_record.user_id}"]]
    elsif operation_record.company.unified_management
      company_tag(authority, operation_record)
    else
      shop_tag(authority, operation_record)
    end
  end

  def company_tag(authority, operation_record)
    scope = User.where(company_id: operation_record.company_id)
    scope = scope.authorities_any(*authority) if authority.present?
    user_ids = select_users(operation_record, scope)
    Message.create_messages(operation_record, user_ids)
    if authority.present?
      [user_ids, Util::Jpush.users_tag(user_ids)]
    else
      [user_ids, ["company_#{operation_record.company_id}"]]
    end
  end

  def shop_tag(authority, operation_record)
    scope = User.where(shop_id: operation_record.shop_id)
    scope = scope.authorities_any(*authority) if authority.present?
    user_ids = select_users(operation_record, scope)
    Message.create_messages(operation_record, user_ids)

    if authority.present?
      [user_ids, Util::Jpush.users_tag(user_ids)]
    else
      [user_ids, ["shop_#{operation_record.shop_id}"]]
    end
  end

  # demands#274
  def select_users(operation_record, scope)
    if operation_record.operation_record_type == "stock_warning"
      users = scope + User.where(id: operation_record.targetable.acquirer_id)
      users.map(&:id).uniq
    else
      scope.pluck(:id)
    end
  end
end
