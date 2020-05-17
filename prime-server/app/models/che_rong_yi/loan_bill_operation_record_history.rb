module CheRongYi
  class LoanBillOperationRecordHistory < Base
    attribute :loan_bill_id, Integer
    attribute :operator_id, Integer # 操作人
    attribute :operator_type, String # 用户类型
    attribute :operator_name, String # 操作人姓名
    attribute :content_id, Integer # 操作内容的ID
    attribute :content_type, String # 操作内容的类型
    attribute :content_state, String # 对应操作内容当前状态，分支状态
    attribute :bill_state, String # 记录当前借款单的状态
    attribute :message, String # 记录时的状态对应的消息
    attribute :note, String # 对应的备注
    attribute :created_at, DateTime
    attribute :updated_at, DateTime

    def bill_state_text
      {
        "borrow_applied" => "借款申请",
        "borrow_submitted" => "借款提交",
        "reviewed" => "借款审核",
        "borrowing" => "借款中",
        "borrow_confirmed" => "已放款",
        "borrow_refused" => "已拒绝",
        "return_applied" => "还款申请",
        "return_submitted" => "还款提交",
        "return_confirmed" => "还款确认",
        "returning" => "还款中",
        "closed" => "已关闭",
        "canceled" => "已取消"
      }.fetch(bill_state, "借款中")
    end

    def content_state_text
      loan_bill_states = {
        "borrow_applied" => "借款申请",
        "borrow_submitted" => "借款提交",
        "reviewed" => "借款审核",
        "borrowing" => "借款中",
        "borrow_confirmed" => "已放款",
        "borrow_refused" => "已拒绝",
        "return_applied" => "还款申请",
        "return_submitted" => "还款提交",
        "return_confirmed" => "还款确认",
        "returning" => "还款中",
        "closed" => "已关闭",
        "canceled" => "已取消"
      }

      replace_cars_bill_states = {
        "replace_apply" => "换车申请",
        "replace_submitted" =>"换车提交",
        "replace_review" => "换车审核",
        "replace_confirmed" => "已换车",
        "replace_refused" => "换车失败"
      }

      repayment_bill_states = {
        "return_applied" => "还款申请",
        "return_submitted" => "还款提交",
        "return_confirmed" => "还款确认",
        "return_closed" => "还款已关闭",
        "return_canceled" => "还款已取消"
      }

      total_states = {
        loan_bill: loan_bill_states,
        repayment_bill: repayment_bill_states,
        replace_cars_bill: replace_cars_bill_states
      }

      total_states.fetch(content_type.to_sym, :loan_bill)
                  .fetch(content_state, "borrow_applied")
    end

    def message_text
      [content_state_text, message].reject { |i| i.blank? }.join("，")
    end
  end
end
