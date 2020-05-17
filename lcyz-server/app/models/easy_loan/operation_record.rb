# == Schema Information
#
# Table name: easy_loan_operation_records # 车融易用户操作记录
#
#  id                    :integer          not null, primary key # 车融易用户操作记录
#  targetable_id         :integer                                # 操作对象
#  targetable_type       :string                                 # 操作对象
#  operation_record_type :string                                 # 事件类型
#  user_id               :integer                                # 操作人ID
#  messages              :jsonb                                  # 操作信息
#  sp_company_id         :integer                                # 对应所属sp公司
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  user_type             :string                                 # 操作人多态
#  detail                :jsonb                                  # 操作记录详情
#

class EasyLoan::OperationRecord < ActiveRecord::Base
  # accessors .................................................................
  # extends ...................................................................
  extend Enumerize
  extend EnumerizeWithGroups
  # includes ..................................................................
  # relationships .............................................................
  belongs_to :targetable, polymorphic: true
  belongs_to :user, polymorphic: true
  # validations ...............................................................
  # callbacks .................................................................
  after_commit :create_messages, on: :create
  # scopes ....................................................................
  scope :ordered, -> { order(id: :desc) }
  # additional config .........................................................
  enumerize :operation_record_type,
            in: %i(loan_bill_state_updated borrow_applied return_applied),
            groups: {
              loan_messagable: %i(loan_bill_state_updated borrow_applied return_applied)
            }
  # class methods .............................................................
  # public instance methods ...................................................
  def state_message_text
    send("#{operation_record_type}_message_text")
  end

  def loan_bill_state_updated_message_text
    I18n.t(
      "easy_loan.operation_record.messages.loan_bill_state_updated".freeze,
      company_name: messages["company_name"],
      state_text: messages["state_text"],
      car_name: messages["car_name"],
      amount_wan: messages["amount_wan"]
    )
  end

  def borrow_applied_message_text
    I18n.t(
      "easy_loan.operation_record.messages.borrow_applied".freeze,
      company_name: messages["company_name"],
      car_name: messages["car_name"],
      amount_wan: messages["amount_wan"]
    )
  end

  def return_applied_message_text
    I18n.t(
      "easy_loan.operation_record.messages.return_applied".freeze,
      company_name: messages["company_name"],
      car_name: messages["car_name"],
      amount_wan: messages["amount_wan"]
    )
  end

  # protected instance methods ................................................
  # private instance methods ..................................................

  private

  def create_messages
    create_loan_messages if in_operation_record_type_loan_messagable?
  end

  def create_loan_messages
    EasyLoan::MessageWorker.perform_in(5.seconds, id)
  end
end
