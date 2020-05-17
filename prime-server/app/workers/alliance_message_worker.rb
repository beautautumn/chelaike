class AllianceMessageWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(operation_record_id)
    operation_record = OperationRecord.find(operation_record_id)

    send(operation_record.operation_record_type.to_sym, operation_record)
  end

  def alliance_invitation_created(operation_record)
    invited_company_ids = operation_record.messages["invited_company_ids"]
    user_ids = alliance_contact_ids(invited_company_ids)

    # send_jpush(operation_record, user_ids)
    send_rong_push(operation_record, user_ids)
  end

  def alliance_invitation_agreed(operation_record)
    alliance_id = operation_record.messages["alliance_id"]
    self_company_id = operation_record.messages["company_id"].to_i
    company_ids = Alliance.find(alliance_id).companies.pluck(:id) - [self_company_id]
    user_ids = alliance_contact_ids(company_ids)

    # send_jpush(operation_record, user_ids)
    send_rong_push(operation_record, user_ids)
  end

  def alliance_invitation_disagreed(operation_record)
    company_ids = [operation_record.messages["company_id"]]
    user_ids = alliance_contact_ids(company_ids)

    # send_jpush(operation_record, user_ids)
    send_rong_push(operation_record, user_ids)
  end

  def alliance_relationship_deleted(operation_record)
    company_ids = [operation_record.messages["company_id"]]
    user_ids = alliance_contact_ids(company_ids)

    # send_jpush(operation_record, user_ids)
    send_rong_push(operation_record, user_ids)
  end

  def alliance_relationship_quit(operation_record)
    company_ids = [operation_record.messages["owner_id"]]
    user_ids = alliance_contact_ids(company_ids)

    # send_jpush(operation_record, user_ids)
    send_rong_push(operation_record, user_ids)
  end

  private

  def send_rong_push(operation_record, user_ids)
    Message.create_messages(operation_record, user_ids)
    RongMessageService.new(operation_record, user_ids).publish
  end

  def send_jpush(operation_record, user_ids)
    Message.create_messages(operation_record, user_ids)

    params = {
      alert: operation_record.alliance_message_text,
      badge: "+1",
      sound: "default",
      extras: {
        operation_record_id: operation_record.id,
        message_type: operation_record.operation_record_type,
        message_id: operation_record.id,
        alliance_id: operation_record.messages["alliance_id"],
        company_id: operation_record.messages["company_id"],
        company_name: operation_record.messages["company_name"]
      }
    }

    payload = JPush::PushPayload.new(
      platform: JPush::Platform.all,
      audience: JPush::Audience.build(
        tag: Util::Jpush.users_tag(user_ids)
      ),
      notification: JPush::Notification.build(
        alert: params[:alert],
        ios: JPush::IOSNotification.build(params),
        android: JPush::AndroidNotification.build(params)
      )
    )

    Util::Jpush.new.send(payload)
  end

  def alliance_contact_ids(company_ids)
    @alliance_contact_ids ||= User.where(company_id: company_ids)
                                  .where("'联盟管理' = ANY (authorities)")
                                  .pluck(:id)
  end
end
