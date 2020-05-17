class StatisticMessageWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(operation_record_id)
    operation_record = OperationRecord.find(operation_record_id)

    Message.create_messages(operation_record, [operation_record.user_id])

    # send_jpush(operation_record, ["user_#{operation_record.user_id}"])
    send_rong_push(operation_record, [operation_record.user_id])
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
end
