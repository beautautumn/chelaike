class IntentionMessageWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(operation_record_id)
    operation_record = OperationRecord.find(operation_record_id)
    user_ids = send(operation_record.operation_record_type, operation_record)

    # target_tag = Util::Jpush.users_tag(user_ids)

    # send_jpush(operation_record, target_tag)

    send_rong_push(operation_record, user_ids)
  end

  def send_rong_push(operation_record, user_ids)
    RongMessageService.new(operation_record, user_ids).publish
  end

  def send_jpush(operation_record, target_tag)
    params = {
      alert: operation_record.intention_message_text,
      badge: "+1",
      sound: "default",
      extras: {
        operation_record_id: operation_record.id,
        message_type: operation_record.operation_record_type,
        intention_id: operation_record.messages["intention_id"]
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

  def intention_reassigned(operation_record)
    user_ids = intention_reassigned_user_ids(operation_record)

    Message.create_messages(operation_record, user_ids)

    user_ids
  end

  def remind_intention_due(operation_record)
    user_id = operation_record.user_id
    Message.create_messages(operation_record, [user_id])
    [user_id]
  end

  def remind_intention_untreated(operation_record)
    intention = operation_record.targetable

    user_ids =  User.where(company_id: intention.company_id)
                    .authorities_any(*intention.intention_type_authority)
                    .pluck(:id)

    Message.create_messages(operation_record, user_ids)

    user_ids
  end

  def expiration_notification(operation_record)
    user_id = operation_record.user_id
    Message.create_messages(operation_record, [user_id])
    [user_id]
  end

  def assigned_acquisition_car_info(operation_record)
    info = operation_record.targetable

    user_ids = [info.acquirer_id]

    Message.create_messages(operation_record, user_ids)

    user_ids
  end

  def intention_reassigned_user_ids(operation_record)
    if operation_record.director_assignee?
      [operation_record.targetable.assignee_id]
    else
      [
        operation_record.targetable.assignee_id,
        operation_record.messages["assignee_id_was"]
      ].select(&:present?).uniq
    end
  end
end
