module EasyLoan
  class MessageWorker
    include Sidekiq::Worker
    sidekiq_options retry: false

    def perform(operation_record_id)
      operation_record = EasyLoan::OperationRecord.find(operation_record_id)

      user_ids = push_tag(operation_record)

      send_rong_push(operation_record, user_ids)
    end

    def send_rong_push(operation_record, user_ids)
      EasyLoan::RongMessageService.new(operation_record, user_ids).publish
    end

    private

    # 发送消息给这个商家对应城市里的金融专员
    def push_tag(operation_record)
      loan_bill = operation_record.targetable
      user_ids = EasyLoanService::LoanBill.new(nil, loan_bill).matched_easy_loan_users.map(&:id)
      # user_ids = [4, 5]
      EasyLoan::Message.create_messages(operation_record, user_ids)
      user_ids
    end
  end
end
