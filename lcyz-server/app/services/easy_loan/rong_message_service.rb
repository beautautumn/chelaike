module EasyLoan
  class RongMessageService
    def initialize(operation_record, user_ids)
      @operation_record = operation_record
      @from_user_id = system_messager_id
      @to_user_ids = user_ids
    end

    def publish
      rong_push = Util::RongPush.new(
        @from_user_id,
        @to_user_ids,
        easy_loan_operation_record_content,
        :easy_loan
      )

      rong_push.send
    end

    private

    def system_messager_id
      EasyLoan::User.find_or_create_by!(
        id: -100, name: "系统消息用户",
        phone: "22222222222"
      )
    end

    def easy_loan_operation_record_content
      content = @operation_record.send("#{@operation_record.operation_record_type}_message_text")

      {
        content: content,
        extra: {
          operation_record_id: @operation_record.id,
          message_type: @operation_record.operation_record_type,
          object_type: @operation_record.targetable_type,
          object_id: @operation_record.targetable_id,
          notification_type: :loan
        }
      }
    end
  end
end
