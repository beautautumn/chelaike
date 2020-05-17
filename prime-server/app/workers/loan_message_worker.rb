class LoanMessageWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(operation_record_id)
    operation_record = OperationRecord.find(operation_record_id)

    user_ids = push_tag(operation_record)

    send_rong_push(operation_record, user_ids)
  end

  def send_rong_push(operation_record, user_ids)
    RongMessageService.new(operation_record, user_ids).publish
  end

  private

  # 只发送给有“融资管理权限”的人
  def push_tag(operation_record)
    authority = operation_record.message_notify_authority
    users = operation_record.company.users.authorities_any(*authority)
    user_ids = users.pluck(:id)
    Message.create_messages(operation_record, user_ids)
    user_ids
  end
end
